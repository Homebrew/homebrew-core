class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v1.28.0/ldc-1.28.0-src.tar.gz"
  sha256 "17fee8bb535bcb8cda0a45947526555c46c045f302a7349cc8711b254e54cf09"
  license "BSD-3-Clause"
  head "https://github.com/ldc-developers/ldc.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_monterey: "47bb936d40170308b783fd5e0adef4cf257919ec57822d3a5aecbca18c8d69c3"
    sha256 arm64_big_sur:  "afdbe7f9e8b4a219d9c2b1444a6fe36236d646d28185a374ae8187d952738e80"
    sha256 monterey:       "82ebc9d435c683f4277495124f1baa6067ded552040caa9db2aeaa10bd3e64db"
    sha256 big_sur:        "bb36be3563085a2485452a5584c2827ae217b284c86d4cfbc30c66bb722cc07c"
    sha256 catalina:       "051f7d508c7668c78a72442f49d213c61ef83e82ca9870b2395d96761eb98378"
    sha256 mojave:         "b2b21fd07e64980443ee696de4f1ff362f4c9db25086e750da33c9fafab1202a"
    sha256 x86_64_linux:   "a7bb1dc2d9df62c276b0f02ff9248f017e5c43b454bc8eeac6406943c88c48bd"
  end

  depends_on "cmake" => :build
  depends_on "libconfig" => :build
  depends_on "pkg-config" => :build
  depends_on "llvm@12"

  uses_from_macos "libxml2" => :build
  # CompilerSelectionError: ldc cannot be built with any available compilers.
  uses_from_macos "llvm" => [:build, :test]

  fails_with :gcc

  resource "ldc-bootstrap" do
    on_macos do
      if Hardware::CPU.intel?
        url "https://github.com/ldc-developers/ldc/releases/download/v1.28.0/ldc2-1.28.0-osx-x86_64.tar.xz"
        sha256 "02472507de988c8b5dd83b189c6df3b474741546589496c2ff3d673f26b8d09a"
      else
        url "https://github.com/ldc-developers/ldc/releases/download/v1.28.0/ldc2-1.28.0-osx-arm64.tar.xz"
        sha256 "f9786b8c28d8af1fdd331d8eb889add80285dbebfb97ea47d5dd9110a7df074b"
      end
    end

    on_linux do
      # ldc 1.27 requires glibc 2.27, which is too new for Ubuntu 16.04 LTS.  The last version we can bootstrap with
      # is 1.26.  Change this when we migrate to Ubuntu 18.04 LTS.
      url "https://github.com/ldc-developers/ldc/releases/download/v1.26.0/ldc2-1.26.0-linux-x86_64.tar.xz"
      sha256 "06063a92ab2d6c6eebc10a4a9ed4bef3d0214abc9e314e0cd0546ee0b71b341e"
    end
  end

  def llvm
    deps.reject { |d| d.build? || d.test? }
        .map(&:to_formula)
        .find { |f| f.name.match? "^llvm" }
  end

  def install
    ENV.cxx11
    (buildpath/"ldc-bootstrap").install resource("ldc-bootstrap")

    if OS.linux?
      # Fix ldc-bootstrap/bin/ldmd2: error while loading shared libraries: libxml2.so.2
      ENV.prepend_path "LD_LIBRARY_PATH", Formula["libxml2"].lib
    end

    mkdir "build" do
      args = std_cmake_args + %W[
        -DLLVM_ROOT_DIR=#{llvm.opt_prefix}
        -DINCLUDE_INSTALL_DIR=#{include}/dlang/ldc
        -DD_COMPILER=#{buildpath}/ldc-bootstrap/bin/ldmd2
      ]
      args << "-DCMAKE_INSTALL_RPATH=#{rpath};@loader_path/#{llvm.opt_lib.relative_path_from(lib)}" if OS.mac?

      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
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
