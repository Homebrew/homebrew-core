class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v1.36.0/ldc-1.36.0-src.tar.gz"
  sha256 "a00c79073123a887c17f446c7782a49556a3512a3d35ab676b7d53ae1bb8d6ef"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/ldc-developers/ldc.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sonoma:   "a702c014b40a7ae93e5aa3d40d53fe48a7967c04ca0039fbdb935d259790153f"
    sha256                               arm64_ventura:  "ad0c37af554a276e470c09b626b00b2a716406f27a3e6b9979d3ef4348c36b9d"
    sha256                               arm64_monterey: "34c09ba60abe8ef72796c710cbd2e6205fe42e5540c7ff213264f86a1fe3ca65"
    sha256                               sonoma:         "a28a1d85609f977f1cf4c579f50c819034c027b63c202773130dd79f829d5876"
    sha256                               ventura:        "e2cea208a0e283ac522b81cb82e8871c207928f08b9d943c43560b6e6c8ce187"
    sha256                               monterey:       "32631d3cbc2403b2f00a0ed1821baf90db46785992ec891591ead9ce8df02c3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d60cc5db0c1b94d4d7c758ff01b2202566060e3c5388ddc086188bccc18c4774"
  end

  depends_on "cmake" => :build
  depends_on "libconfig" => :build
  depends_on "pkg-config" => :build
  depends_on "llvm"

  uses_from_macos "libxml2" => :build

  resource "ldc-bootstrap" do
    on_macos do
      on_arm do
        url "https://github.com/ldc-developers/ldc/releases/download/v1.36.0/ldc2-1.36.0-osx-arm64.tar.xz"
        sha256 "ba8440e2b235b3584bc129de136563996db91cd0a35e10bcccf316bee3f23a98"
      end
      on_intel do
        url "https://github.com/ldc-developers/ldc/releases/download/v1.36.0/ldc2-1.36.0-osx-x86_64.tar.xz"
        sha256 "7740fefcb32c19c23bf5ce4dea6e5412329f27ffa511c4101dd96b1f44999429"
      end
    end
    on_linux do
      on_arm do
        url "https://github.com/ldc-developers/ldc/releases/download/v1.36.0/ldc2-1.36.0-linux-aarch64.tar.xz"
        sha256 "11cb6c554b351a00525089659c97a0e6fc568b1814e69407600315997d1852eb"
      end
      on_intel do
        url "https://github.com/ldc-developers/ldc/releases/download/v1.36.0/ldc2-1.36.0-linux-x86_64.tar.xz"
        sha256 "2d418462d1c3909f5889298d97de061d023850a371ea9d418fc3fd2d4b7e8b19"
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
    system bin/"ldc2", "-flto=thin", "test.d"
    assert_match "Hello, world!", shell_output("./test")
    system bin/"ldc2", "-flto=full", "test.d"
    assert_match "Hello, world!", shell_output("./test")
    system bin/"ldmd2", "test.d"
    assert_match "Hello, world!", shell_output("./test")
  end
end
