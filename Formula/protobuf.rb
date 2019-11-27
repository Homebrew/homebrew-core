class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://github.com/protocolbuffers/protobuf/"
  url "https://github.com/protocolbuffers/protobuf.git",
      :tag      => "v3.11.0",
      :revision => "ab5b61bf2f0fb1ac485be1b82fffca153c2509ed"
  head "https://github.com/protocolbuffers/protobuf.git"

  bottle do
    cellar :any
    sha256 "8062333a7a30b5b3bb24b24bc86a1b954f0112a8433240bac960f0abc5ae2342" => :catalina
    sha256 "ba114c5f8e1224c02ca76112ebbe416588910c3910edc0c61e6ae2b53fe5cd28" => :mojave
    sha256 "66b2e6935eb30637cb4d2ff61469fc315ec95c33ca1cc21593f5bb4c6cf16c5b" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "python" => [:build, :test]

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/3e/edcf6fef41d89187df7e38e868b2dd2182677922b600e880baad7749c865/six-1.13.0.tar.gz"
    sha256 "30f610279e8b2578cab6db20741130331735c781b56053c59c4076da27f06b66"
  end

  def install
    # Don't build in debug mode. See:
    # https://github.com/Homebrew/homebrew/issues/9279
    # https://github.com/protocolbuffers/protobuf/blob/5c24564811c08772d090305be36fae82d8f12bbe/configure.ac#L61
    ENV.prepend "CXXFLAGS", "-DNDEBUG"
    ENV.cxx11

    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-zlib"
    system "make"
    system "make", "check"
    system "make", "install"

    # Install editor support and examples
    doc.install "editors", "examples"

    ENV.append_to_cflags "-I#{include}"
    ENV.append_to_cflags "-L#{lib}"

    resource("six").stage do
      system "python3", *Language::Python.setup_install_args(libexec)
    end
    chdir "python" do
      system "python3", *Language::Python.setup_install_args(libexec),
                        "--cpp_implementation"
    end

    version = Language::Python.major_minor_version "python3"
    site_packages = "lib/python#{version}/site-packages"
    pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
    (prefix/site_packages/"homebrew-protobuf.pth").write pth_contents
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
    system "python3", "-c", "import google.protobuf"
  end
end
