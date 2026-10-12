class Edgcpp < Formula
  desc "Edison Design Group C/C++ compiler front end"
  homepage "https://edgcpp.org"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/edgcpp/compiler.git", branch: "main"

  stable do
    url "https://github.com/edgcpp/compiler/archive/refs/tags/7.0.tar.gz"
    sha256 "ecb392e329e2fd6790fc8105061c7104392d1f4509a92337e385a4972db778e5"

    # Build system fix
    # Remove on next version bump
    patch do
      url "https://github.com/edgcpp/compiler/commit/ca5890bab86381b0fb0c6a5202dd27cde567181b.patch?full_index=1"
      sha256 "bab2a0268ecc6cd3dd46072637ac42f2b8fb1035ad0106fa8e60b5f353d96bd7"
      type :backport
    end
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python@3.14" => :build

  on_macos do
    fails_with :gcc
  end

  on_linux do
    fails_with :clang
  end

  deny_network_access!

  def install
    # The default -Os causes a build failure and the build script forces -O3 anyway, so may as well make it official
    ENV.O3

    # Set up target-specific ENV and cmake args
    cmake_args = std_cmake_args
    if OS.mac?
      cmake_args += ["-DEDG_PREFERRED_LINKER=ld"]
      if Hardware::CPU.arm?
        preset_name = "macos-arm-clang-release"
        edg_base = "bases/cmake-native/macos-arm/clang"
      elsif Hardware::CPU.intel?
        preset_name = "macos-x86-clang-release"
        edg_base = "bases/cmake-native/macos-x86_64/clang"
      else
        odie "Unsupported architecture"
      end
    elsif OS.linux?
      preset_name = "linux-gcc-release"
      edg_base = "bases/docker/dev-env/gcc"
      cmake_args += ["-DEDG_PREFERRED_LINKER=gold"]
    else
      odie "Unsupported operating system"
    end
    ENV["EDG_BASE"] = buildpath/edg_base

    system "cmake", "--preset", preset_name, "-S", ".", "-B", "build", *cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Manually install the various parts, since `cmake --install` does almost nothing
    lib.install "build/lib/libC.a"
    bin.install Dir["build/bin/*"]
    share.install Dir["include_*"]
    share.install Dir["build/lib_*"]
    rm_r share/"lib_src"
    libexec.install "util/eccp.sh"
    share.install edg_base => "edg_base"
    rm share/"edg_base/include"
    (share/"edg_base").install_symlink share/"include_c++" => "include"
    bin.env_script_all_files libexec, {
      "CPFE"             => libexec/"cpfe",
      "CPFE_CP"          => libexec/"cpfe-cp",
      "ECCP"             => libexec/"eccp.sh",
      "ECCP_LIBDIR"      => lib,
      "EDG_MUNCH_PATH"   => libexec/"edg_munch",
      "EDG_DECODE_PATH"  => libexec/"edg_decode",
      "EDG_PRELINK_PATH" => libexec/"edg_prelink",
      "EDG_BASE"         => share/"edg_base",
    }
  end

  test do
    (testpath/"test-c.c").write <<~C
      int main(int const argc, char const * const argv) {
        return 0;
      }
    C
    # assert no errors produced
    assert_equal "", shell_output("#{bin}/cpfe --no_code_gen --c test-c.c").strip

    (testpath/"test-cpp.cpp").write <<~CPP
      class test {
      public:
        int retcode;
        test(int r) : retcode(r) {}
      };

      int main(int const argc, char const * const argv) {
        test x(0);
        return x.retcode;
      }
    CPP
    # assert no errors produced
    assert_equal "", shell_output("#{bin}/cpfe --no_code_gen --c++ test-cpp.cpp").strip
  end
end
