class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://github.com/google/protobuf/"

  stable do
    url "https://github.com/google/protobuf/releases/download/v2.6.1/protobuf-2.6.1.tar.bz2"
    sha256 "ee445612d544d885ae240ffbcbf9267faa9f593b7b101f21d58beceb92661910"

    # Fixes the unexpected identifier error when compiling software against protobuf:
    # https://github.com/google/protobuf/issues/549
    patch :p1, :DATA
  end

  bottle do
    revision 5
    sha256 "b1a6c4508ec66e706929e3e34a5b57b3c881c5ac1e3d0fc7c4b3598f97902c7f" => :el_capitan
    sha256 "5c21d50d1d3ca2dc2906bba174bfb4ec0d55c0f16bac5541abf3180e68f885c2" => :yosemite
    sha256 "6f6a30044450bb3e2d420fea3435d0c84594b197ea0d3a54bca473e3b4c855b5" => :mavericks
  end

  devel do
    url "https://github.com/google/protobuf/archive/v3.0.0-beta-3.tar.gz"
    sha256 "d8d11564ff4085e7095cf5601fdc094946e6dbb0085863829668eb3a50b1ae0d"
    version "3.0.0-beta-3"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  head do
    url "https://github.com/google/protobuf.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # this will double the build time approximately if enabled
  option "with-test", "Run build-time check"
  deprecated_option "with-check" => "with-test"

  option :universal
  option :cxx11

  option "without-python", "Build without python support"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard

  fails_with :llvm do
    build 2334
  end

  resource "setuptools" do
    url "https://pypi.python.org/packages/source/s/setuptools/setuptools-20.9.0.tar.gz"
    sha256 "2a360c782e067f84840315bcdcb5ed6c7c841cdedf6444f3232ab4a8b3204ac1"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "python-dateutil" do
    url "https://pypi.python.org/packages/source/p/python-dateutil/python-dateutil-2.5.2.tar.gz"
    sha256 "063907ef47f6e187b8fe0728952e4effb587a34f2dc356888646f9b71fbb2e4b"
  end

  resource "pytz" do
    url "https://pypi.python.org/packages/source/p/pytz/pytz-2016.3.tar.bz2"
    sha256 "c193dfa167ac32c8cb96f26cbcd92972591b22bda0bac3effdbdb04de6cc55d6"
  end

  resource "python-gflags" do
    url "https://pypi.python.org/packages/source/p/python-gflags/python-gflags-2.0.tar.gz"
    sha256 "0dff6360423f3ec08cbe3bfaf37b339461a54a21d13be0dd5d9c9999ce531078"
  end

  resource "google-apputils" do
    url "https://pypi.python.org/packages/source/g/google-apputils/google-apputils-0.4.2.tar.gz"
    sha256 "47959d0651c32102c10ad919b8a0ffe0ae85f44b8457ddcf2bdc0358fb03dc29"
  end

  # Upstream's autogen script fetches this for devel/head if not present
  # but does no integrity verification & mandates being online to install.
  resource "gmock" do
    url "https://googlemock.googlecode.com/files/gmock-1.7.0.zip"
    sha256 "26fcbb5925b74ad5fc8c26b0495dfc96353f4d553492eb97e85a8a6d2f43095b"
  end

  def install
    # Don't build in debug mode. See:
    # https://github.com/Homebrew/homebrew/issues/9279
    # https://github.com/google/protobuf/blob/5c24564811c08772d090305be36fae82d8f12bbe/configure.ac#L61
    ENV.prepend "CXXFLAGS", "-DNDEBUG"
    ENV.universal_binary if build.universal?
    ENV.cxx11 if build.cxx11?

    if build.devel? || build.head?
      (buildpath/"gmock").install resource("gmock")
      system "./autogen.sh"
    end

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-zlib"
    system "make"
    system "make", "check" if build.with?("test") || build.bottle?
    system "make", "install"

    # Install editor support and examples
    doc.install "editors", "examples"

    if build.with? "python"
      # google-apputils is a build-time dependency
      ENV.prepend_create_path "PYTHONPATH", buildpath/"homebrew/lib/python2.7/site-packages"
      %w[setuptools six python-dateutil pytz python-gflags google-apputils].each do |package|
        resource(package).stage do
          system "python", *Language::Python.setup_install_args(buildpath/"homebrew")
        end
      end
      # google is a namespace package and .pth files aren't processed from
      # PYTHONPATH
      touch buildpath/"homebrew/lib/python2.7/site-packages/google/__init__.py"
      chdir "python" do
        ENV.append_to_cflags "-I#{include}"
        ENV.append_to_cflags "-L#{lib}"
        args = Language::Python.setup_install_args libexec
        args << "--cpp_implementation"
        system "python", *args
      end
      site_packages = "lib/python2.7/site-packages"
      pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
      (prefix/site_packages/"homebrew-protobuf.pth").write pth_contents
    end
  end

  def caveats; <<-EOS.undent
    Editor support and examples have been installed to:
      #{doc}
    EOS
  end

  test do
    testdata = if devel?
      <<-EOS.undent
        syntax = "proto3";
        package test;
        message TestCase {
          string name = 4;
        }
        message Test {
          repeated TestCase case = 1;
        }
        EOS
    else
      <<-EOS.undent
        package test;
        message TestCase {
          required string name = 4;
        }
        message Test {
          repeated TestCase case = 1;
        }
        EOS
    end
    (testpath/"test.proto").write testdata
    system bin/"protoc", "test.proto", "--cpp_out=."
    system "python", "-c", "import google.protobuf" if build.with? "python"
  end
end

__END__
diff --git a/src/google/protobuf/descriptor.h b/src/google/protobuf/descriptor.h
index 67afc77..504d5fe 100644
--- a/src/google/protobuf/descriptor.h
+++ b/src/google/protobuf/descriptor.h
@@ -59,6 +59,9 @@
 #include <vector>
 #include <google/protobuf/stubs/common.h>

+#ifdef TYPE_BOOL
+#undef TYPE_BOOL
+#endif

 namespace google {
 namespace protobuf {
