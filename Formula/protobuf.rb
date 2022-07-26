class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://github.com/protocolbuffers/protobuf/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v21.4/protobuf-all-21.4.tar.gz"
  sha256 "6c5e1b0788afba4569aeebb2cfe205cb154aa01deacaba0cd26442f3b761a836"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "77fef8828b8770c4cfcbb5368c4e048919bdb92c165406ae3eb028717bfd6216"
    sha256 cellar: :any,                 arm64_big_sur:  "b0169bd1db6dbae00dceb6380c05d77c8adec92e9c774752511d6637c3ae28e6"
    sha256 cellar: :any,                 monterey:       "d85deed525fbbd9c2daf8bfe2209f589c5ce529b82161200bf4e1dd9cafb5b9a"
    sha256 cellar: :any,                 big_sur:        "e07f77bf8cf1e86d1746ee6d696825402e936fc7e06a0e48b04e2c43503476e0"
    sha256 cellar: :any,                 catalina:       "d35481b0bbbe156006515458cf6240194a6fc51d44cc8ae8540cb8029d3fcf48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afd43fd5a7048133a21237e2c260759e53fa86c7dd4c487c6255eec409ba8fa7"
  end

  head do
    url "https://github.com/protocolbuffers/protobuf.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "python@3.10" => [:build, :test]
  # The Python3.9 bindings can be removed when Python3.9 is made keg-only.
  depends_on "python@3.9" => [:build, :test]

  uses_from_macos "zlib"

  def install
    # Don't build in debug mode. See:
    # https://github.com/Homebrew/homebrew/issues/9279
    # https://github.com/protocolbuffers/protobuf/blob/5c24564811c08772d090305be36fae82d8f12bbe/configure.ac#L61
    ENV.prepend "CXXFLAGS", "-DNDEBUG"
    ENV.cxx11

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-zlib"
    system "make"
    system "make", "check"
    system "make", "install"

    # Install editor support and examples
    pkgshare.install "editors/proto.vim", "examples"
    elisp.install "editors/protobuf-mode.el"

    ENV.append_to_cflags "-I#{include}"
    ENV.append_to_cflags "-L#{lib}"

    cd "python" do
      ["3.9", "3.10"].each do |xy|
        site_packages = prefix/Language::Python.site_packages("python#{xy}")
        system "python#{xy}", *Language::Python.setup_install_args(prefix),
                              "--install-lib=#{site_packages}",
                              "--cpp_implementation"
      end
    end
  end

  test do
    testdata = <<~EOS
      syntax = "proto3";
      package test;
      message TestCase {
        string name = 4;
      }
      message Test {
        repeated TestCase case = 1;
      }
    EOS
    (testpath/"test.proto").write testdata
    system bin/"protoc", "test.proto", "--cpp_out=."
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import google.protobuf"
    system Formula["python@3.10"].opt_bin/"python3", "-c", "import google.protobuf"
  end
end
