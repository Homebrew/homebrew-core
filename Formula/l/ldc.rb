class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v1.39.0/ldc-1.39.0-src.tar.gz"
  sha256 "839bac36f6073318e36f0b163767e03bdbd3f57d99256b97494ac439b59a4562"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/ldc-developers/ldc.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sequoia: "16de7a20bf322c043232d9e452e948a76e39222c4302dd473f56ac54e9f124b3"
    sha256                               arm64_sonoma:  "a5b5090830d2809662e9eb7fd4ed3264e82720f6845f35cb594cc934603ed84d"
    sha256                               arm64_ventura: "c41c88fb61a60ec842c81e2c4ca64c065b2c368c83f09365207f7da959dc8cda"
    sha256                               sonoma:        "83747bfe0e1c14fd8f29c4c3b15f12919057694a1be31b5a66325e9bf74c6aea"
    sha256                               ventura:       "c48b3f215c92ca8907fd2938adbd987a6c9738607f7adf8c5bcf74401795e07b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0351b9c88bf73003a30db5dec85e71c9e67358a3190563e5fa7b532d28ee8aba"
  end

  depends_on "cmake" => :build
  depends_on "libconfig" => :build
  depends_on "pkg-config" => :build
  depends_on "llvm@18"
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
    with_env(PATH: "#{llvm.opt_bin}:#{ENV["PATH"]}") do
      system bin/"ldc2", "-flto=thin", "--linker=lld", "test.d"
      assert_match "Hello, world!", shell_output("./test")
      system bin/"ldc2", "-flto=full", "--linker=lld", "test.d"
      assert_match "Hello, world!", shell_output("./test")
    end
    system bin/"ldmd2", "test.d"
    assert_match "Hello, world!", shell_output("./test")
  end
end
