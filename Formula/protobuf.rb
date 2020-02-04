class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://github.com/protocolbuffers/protobuf/"
  url "https://github.com/protocolbuffers/protobuf.git",
      :tag      => "v3.11.3",
      :revision => "498de9f761bef56a032815ee44b6e6dbe0892cc4"
  head "https://github.com/protocolbuffers/protobuf.git"

  bottle do
    cellar :any
    sha256 "3fdda0c68757e397a80cf6d87ffb1f6570f459c368a1288c316e932687c5a98f" => :catalina
    sha256 "c2c8d923c866867eec44813a8264684bd6deb5fc98fc0ca257eaf1dea34ba183" => :mojave
    sha256 "a772a6c0dc4a95ae6a2cc200664995ef2749d08da8e0965c9b18e932cd5ff19c" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "python" => [:build, :test]

  resource "six" do
    url "https://files.pythonhosted.org/packages/21/9f/b251f7f8a76dec1d6651be194dfba8fb8d7781d10ab3987190de8391d08e/six-1.14.0.tar.gz"
    sha256 "236bdbdce46e6e6a3d61a337c0f8b763ca1e8717c03b369e87a7ec7ce1319c0a"
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
