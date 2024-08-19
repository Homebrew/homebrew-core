class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v1.39.0/ldc-1.39.0-src.tar.gz"
  sha256 "839bac36f6073318e36f0b163767e03bdbd3f57d99256b97494ac439b59a4562"
  license "BSD-3-Clause"
  head "https://github.com/ldc-developers/ldc.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sonoma:   "b8c30a4ac033e903d377e07d94b3ed095f2691b56bd99d27a76d48ff665a93d4"
    sha256                               arm64_ventura:  "99251ae8e6f5bdcd6f6eb66b3999d7c4ea6960a009dfe633da27d9f75c659bc0"
    sha256                               arm64_monterey: "44ac5441951ba752a05850a2cf1bdd2ce43081a8e0734ee61ea15cbd93f4b910"
    sha256                               sonoma:         "9651940f505ace172f4655a03d11ce880055cc40bd4b2fee52b0603ad144ec98"
    sha256                               ventura:        "24dc413bca528d23a5664683c1c37d975be5e5222805cc0f8bb51a4380015342"
    sha256                               monterey:       "de03f99ea9eab85b3e3f7676848043ccff79d5a193f0dd03e633f7f642798da6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e6ce62025173793a521b2186cbf741e135ba60d61819cef73f112810057c1de"
  end

  depends_on "cmake" => :build
  depends_on "libconfig" => :build
  depends_on "pkg-config" => :build
  depends_on "llvm"
  depends_on "zstd"

  uses_from_macos "libxml2" => :build

  resource "ldc-bootstrap" do
    on_macos do
      on_arm do
        url "https://github.com/ldc-developers/ldc/releases/download/v1.39.0/ldc2-1.39.0-osx-arm64.tar.xz"
        sha256 "4f0285d6ab0f335f97a8cae1ebc951eb5e68face0645f2b791b8d5399689ad95"
      end
      on_intel do
        url "https://github.com/ldc-developers/ldc/releases/download/v1.39.0/ldc2-1.39.0-osx-x86_64.tar.xz"
        sha256 "751ebe8c744fa3375a08dfb67d80569e985944f3fb7f551affa5d5052117beb6"
      end
    end
    on_linux do
      on_arm do
        url "https://github.com/ldc-developers/ldc/releases/download/v1.39.0/ldc2-1.39.0-linux-aarch64.tar.xz"
        sha256 "bafba183432dc8c277d07880d6dd17b4b1b3050808bef0be07875a41cda6dfcf"
      end
      on_intel do
        url "https://github.com/ldc-developers/ldc/releases/download/v1.39.0/ldc2-1.39.0-linux-x86_64.tar.xz"
        sha256 "f50cdacd11c923b96e57edab15cacff6a30c7ebff4b7e495fc684eed0a27ae17"
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
    # Fix ldc-bootstrap/bin/ldmd2: error while loading shared libraries: libxml2.so.2
    ENV.prepend_path "LD_LIBRARY_PATH", Formula["libxml2"].opt_lib if OS.linux?
    # Work around LLVM 16+ build failure due to missing -lzstd when linking lldELF
    # Issue ref: https://github.com/ldc-developers/ldc/issues/4478
    inreplace "CMakeLists.txt", " -llldELF ", " -llldELF -lzstd "

    (buildpath/"ldc-bootstrap").install resource("ldc-bootstrap")

    args = %W[
      -DLLVM_ROOT_DIR=#{llvm.opt_prefix}
      -DINCLUDE_INSTALL_DIR=#{include}/dlang/ldc
      -DD_COMPILER=#{buildpath}/ldc-bootstrap/bin/ldmd2
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

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
    with_env(PATH: "#{Formula["llvm"].opt_bin}:#{ENV["PATH"]}") do
      system bin/"ldc2", "-flto=thin", "--linker=lld", "test.d"
      assert_match "Hello, world!", shell_output("./test")
      system bin/"ldc2", "-flto=full", "--linker=lld", "test.d"
      assert_match "Hello, world!", shell_output("./test")
    end
    system bin/"ldmd2", "test.d"
    assert_match "Hello, world!", shell_output("./test")
  end
end
