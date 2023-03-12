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
    sha256                               arm64_ventura:  "4e7fbf9856f9c0e18d22adb2aaafd58bc014c1dd0224c724ac4bbd9edfcb1e61"
    sha256                               arm64_monterey: "40e61a7c3999a205cda234f83b6cc2fa89d56bc03e634bfebc5694aa9a2dbd24"
    sha256                               arm64_big_sur:  "5da4191fe6a028b6449105261fb1373c49b38a612b17b89fac0323c988ddd02b"
    sha256                               ventura:        "87b923166a2ca3bf2cabffac9d4f1be5859d5d9d49a5b681a87d201f31ae440e"
    sha256                               monterey:       "40b012c3abb7d359d4f3f618231e365487cb6671827a9e43d278fdd52c1d2c8a"
    sha256                               big_sur:        "3a5f121ac59dae6657ebec206dd486ff1e5f3d919362fce1116043d8bdb8c22d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "616506d79bd4adc591bf729fc8937adb1efd0be81346a48ca163cb458950646e"
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
