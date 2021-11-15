class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://github.com/protocolbuffers/protobuf/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v3.17.3/protobuf-all-3.17.3.tar.gz"
  sha256 "77ad26d3f65222fd96ccc18b055632b0bfedf295cb748b712a98ba1ac0b704b2"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a501c2a8db322b604ae4426e784f0d2050fc21e36f69f825ab61ad63d6923668"
    sha256 cellar: :any,                 arm64_big_sur:  "ef7a56961e918e7626e099d18ad87d2ad5414ccc2086211d5dd4f6509d7f4de5"
    sha256 cellar: :any,                 monterey:       "1e94ea6a18487309aaf24c25c0be5b7d95d1f1e04aa4aaf00e9b55618a063815"
    sha256 cellar: :any,                 big_sur:        "d1060a6f73000c9c46a1954397a6375fb41c409d7b3cb7206fc69488313b4855"
    sha256 cellar: :any,                 catalina:       "2f25a4051028d54de1b5527826f39815858b89040f39f14866472c8aa6bfb4e1"
    sha256 cellar: :any,                 mojave:         "7e6d2eb1baee925d8a0776e9dc9fbcb267e1de5c45d2b648b6a60457f0519667"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a7178716cb915c19725d6e21bde91b8c7059e0cf6ffd7e3ab2cd1746a1a2d32"
  end

  head do
    url "https://github.com/protocolbuffers/protobuf.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "python@3.9" => [:build, :test]
  depends_on "six"

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

    chdir "python" do
      system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(prefix),
                        "--cpp_implementation"
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
  end
end
