class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v1.32.0/ldc-1.32.0-src.tar.gz"
  sha256 "c4ee0bf91b416dd5641353d9b267b6a48600c499c782beb112d2e460e329beac"
  license "BSD-3-Clause"
  head "https://github.com/ldc-developers/ldc.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_ventura:  "bf8f2b116be3961fad2d4f0b5fbcef52ac70ecd429bab391facd2da5b9ab4656"
    sha256                               arm64_monterey: "a1efb0d2e4a8f49176652cea25ddb3bc598e3d29866b4e3627c5a7f42c106d21"
    sha256                               arm64_big_sur:  "910efb097fed8743ae7fd418ad3142a8723536b4627cd43bfa56ff081c7ad90c"
    sha256                               ventura:        "75afa7b2ccf78e2a7b9c64e26045ad95d2a868d26d2982e9af219eb5ef6c70d5"
    sha256                               monterey:       "a405256e6fac9bed2ff5be246a709c2bca3609ae1abdf857b430b884cf2b8233"
    sha256                               big_sur:        "548a5b99452b63dc237cf6f866da1e2490e73de7e07a513e2f5fda7cf5bfd7f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "374432ec2f6499a77d06873656434d838f91016a6b361d19d45d4aa86540c77e"
  end

  depends_on "cmake" => :build
  depends_on "libconfig" => :build
  depends_on "pkg-config" => :build
  depends_on "llvm@14" # LLVM 15 issue: https://github.com/ldc-developers/ldc/issues/4042

  uses_from_macos "libxml2" => :build

  resource "ldc-bootstrap" do
    on_macos do
      on_arm do
        url "https://github.com/ldc-developers/ldc/releases/download/v1.28.1/ldc2-1.28.1-osx-arm64.tar.xz"
        sha256 "9bddeb1b2c277019cf116b2572b5ee1819d9f99fe63602c869ebe42ffb813aed"
      end
      on_intel do
        url "https://github.com/ldc-developers/ldc/releases/download/v1.28.1/ldc2-1.28.1-osx-x86_64.tar.xz"
        sha256 "9aa43e84d94378f3865f69b08041331c688e031dd2c5f340eb1f3e30bdea626c"
      end
    end
    on_linux do
      on_arm do
        url "https://github.com/ldc-developers/ldc/releases/download/v1.28.1/ldc2-1.28.1-linux-aarch64.tar.xz"
        sha256 "158cf484456445d4f59364b6e74881d90ec5fe78956fc62f7f7a4db205670110"
      end
      on_intel do
        url "https://github.com/ldc-developers/ldc/releases/download/v1.28.1/ldc2-1.28.1-linux-x86_64.tar.xz"
        sha256 "0195172c3a18d4eaa15a06193fea295a22e21adbfbcb7037691c630f191bceb2"
      end
    end
  end

  def llvm
    deps.reject { |d| d.build? || d.test? }
        .map(&:to_formula)
        .find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    ENV.cxx11
    (buildpath/"ldc-bootstrap").install resource("ldc-bootstrap")

    args = %W[
      -DLLVM_ROOT_DIR=#{llvm.opt_prefix}
      -DINCLUDE_INSTALL_DIR=#{include}/dlang/ldc
      -DD_COMPILER=#{buildpath}/ldc-bootstrap/bin/ldmd2
    ]

    args += if OS.mac?
      ["-DCMAKE_INSTALL_RPATH=#{rpath};#{rpath(source: lib, target: llvm.opt_lib)}"]
    else
      # Fix ldc-bootstrap/bin/ldmd2: error while loading shared libraries: libxml2.so.2
      ENV.prepend_path "LD_LIBRARY_PATH", Formula["libxml2"].opt_lib
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Don't set CC=llvm_clang since that won't be in PATH,
    # nor should it be used for the test.
    ENV.method(DevelopmentTools.default_compiler).call

    (testpath/"test.d").write <<~EOS
      import std.stdio;
      void main() {
        writeln("Hello, world!");
      }
    EOS
    system bin/"ldc2", "test.d"
    assert_match "Hello, world!", shell_output("./test")
    system bin/"ldc2", "-flto=thin", "test.d"
    assert_match "Hello, world!", shell_output("./test")
    system bin/"ldc2", "-flto=full", "test.d"
    assert_match "Hello, world!", shell_output("./test")
    system bin/"ldmd2", "test.d"
    assert_match "Hello, world!", shell_output("./test")
  end
end
