class ProtobufAT35 < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://github.com/google/protobuf/"
  url "https://github.com/google/protobuf/archive/v3.5.2.tar.gz"
  sha256 "4ffd420f39f226e96aebc3554f9c66a912f6cad6261f39f194f16af8a1f6dab2"

  keg_only :versioned_formula

  # this will double the build time approximately if enabled
  option "with-test", "Run build-time check"
  option "without-python@2", "Build without python2 support"

  deprecated_option "with-check" => "with-test"
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

  # Upstream's autogen script fetches this if not present
  # but does no integrity verification & mandates being online to install.
  resource "gmock" do
    url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/googlemock/gmock-1.7.0.zip"
    mirror "https://dl.bintray.com/homebrew/mirror/gmock-1.7.0.zip"
    sha256 "26fcbb5925b74ad5fc8c26b0495dfc96353f4d553492eb97e85a8a6d2f43095b"
  end

  needs :cxx11

  def install
    # Don't build in debug mode. See:
    # https://github.com/Homebrew/homebrew/issues/9279
    # https://github.com/google/protobuf/blob/5c24564811c08772d090305be36fae82d8f12bbe/configure.ac#L61
    ENV.prepend "CXXFLAGS", "-DNDEBUG"
    ENV.cxx11

    (buildpath/"gmock").install resource("gmock")
    system "./autogen.sh"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-zlib"
    system "make"
    system "make", "check" if build.with?("test") || build.bottle?
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
    if build.with? "python@2"
      site_packages = Pathname.new("#{ENV["HOME"]}/Library/Python/2.7/lib/python/site-packages")
      protobuf_pth = lib/"python2.7/site-packages/homebrew-protobuf.pth"
      site_packages.realpath.install_symlink protobuf_pth
      system "python2.7", "-c", "import google.protobuf"
    end
    if build.with? "python"
      xy = Language::Python.major_minor_version "python3"
      site_packages = Pathname.new("#{ENV["HOME"]}/Library/Python/#{xy}/lib/python/site-packages")
      protobuf_pth = lib/"python#{xy}/site-packages/homebrew-protobuf.pth"
      site_packages.mkpath
      site_packages.realpath.install_symlink protobuf_pth
      system "python3", "-c", "import google.protobuf"
    end
  end
end
