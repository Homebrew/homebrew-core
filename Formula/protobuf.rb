class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://github.com/protocolbuffers/protobuf/"
  url "https://github.com/protocolbuffers/protobuf.git",
      :tag      => "v3.6.1.3",
      :revision => "66dc42d891a4fc8e9190c524fd67961688a37bbe"
  head "https://github.com/protocolbuffers/protobuf.git"

  bottle do
    cellar :any
    sha256 "f299e4a5e34e5795eb3d89ca0aaae018e476c17d92f98dd93eeebeb47dbb17c5" => :mojave
    sha256 "d8f2a28e7e99f5046472992f41fe59c3344f2336435f21b6cfa57c433cf20fc8" => :high_sierra
    sha256 "52eedfd81a251dbbc72d2ddbe78e1a54c651792bed0601b57c5ef31a53a6b62d" => :sierra
  end

  option "without-python@2", "Build without python2 support"

  deprecated_option "without-python" => "with-python@2"
  deprecated_option "with-python3" => "with-python"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "python@2" => :recommended
  depends_on "python" => :optional

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  needs :cxx11

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
    system "make", "check" if build.bottle?
    system "make", "install"

    # Install editor support and examples
    doc.install "editors", "examples"

    Language::Python.each_python(build) do |python, version|
      resource("six").stage do
        system python, *Language::Python.setup_install_args(libexec)
      end
      chdir "python" do
        ENV.append_to_cflags "-I#{include}"
        ENV.append_to_cflags "-L#{lib}"
        args = Language::Python.setup_install_args libexec
        args << "--cpp_implementation"
        system python, *args
      end
      site_packages = "lib/python#{version}/site-packages"
      pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
      (prefix/site_packages/"homebrew-protobuf.pth").write pth_contents
    end
  end

  def caveats; <<~EOS
    Editor support and examples have been installed to:
      #{doc}
  EOS
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
    system "python2.7", "-c", "import google.protobuf" if build.with? "python@2"
    system "python3", "-c", "import google.protobuf" if build.with? "python"
  end
end
