class ProtobufAT26 < Formula
  desc "Protocol buffers - Google data interchange format"
  homepage "https://github.com/google/protobuf/"
  url "https://github.com/google/protobuf/releases/download/v2.6.0/protobuf-2.6.0.tar.bz2"
  sha256 "0a2f8533b2e0587a2b4efce0c4c8aea21bbfae1c41c466634d958dedf580f6aa"

  bottle do
    sha256 "188fe3c8779e7c0568829bff058ea06244f17f4b736dd06a32b087a1c579268d" => :high_sierra
    sha256 "86267a38f98ad22da8d222ff0cbaff8ffb65e8b7f56c7bad788f1a2c451ff668" => :sierra
    sha256 "10be7a7a45c9ea4ec06f70f62522f3296f3d3b49ec6fb9e3fe071268f262ef88" => :el_capitan
    sha256 "6337d6ac951577be7ec1bac4587b6c91325bacb53f6e3523ced7bd4b78fd6f7d" => :yosemite
  end

  keg_only :versioned_formula

  # this will double the build time approximately if enabled
  option "with-test", "Run build-time check"
  option "without-python", "Build without python support"
  option :cxx11

  depends_on "python" => :recommended if MacOS.version <= :snow_leopard

  deprecated_option "with-check" => "with-test"

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/64/1dc5e5976b17466fd7d712e59cbe9fb1e18bec153109e5ba3ed6c9102f1a/six-1.9.0.tar.gz"
    sha256 "e24052411fc4fbd1f672635537c3fc2330d9481b18c0317695b46259512c91d5"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/62/fe/45044dfa6bfa6ff18ddfe1df85fbf01d333c284b94e8c9a02fe12241c8cf/python-dateutil-2.4.1.tar.bz2"
    sha256 "a9f62b12e28f11c732ad8e255721a9c7ab905f9479759491bc1f1e91de548d0f"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/63/15/8cdc183c669ef4c870099848b6fb37f11e5aeb2fa06601d0015ac4201e51/pytz-2014.10.tar.bz2"
    sha256 "387f968fde793b142865802916561839f5591d8b4b14c941125eb0fca7e4e58d"
  end

  resource "python-gflags" do
    url "https://files.pythonhosted.org/packages/46/47/12c17c3216c04a85e5ffd9163ad09f0c1661c2cc2ccc0faf70e39cb8dc96/python-gflags-2.0.tar.gz"
    sha256 "0dff6360423f3ec08cbe3bfaf37b339461a54a21d13be0dd5d9c9999ce531078"
  end

  resource "google-apputils" do
    url "https://files.pythonhosted.org/packages/69/66/a511c428fef8591c5adfa432a257a333e0d14184b6c5d03f1450827f7fe7/google-apputils-0.4.2.tar.gz"
    sha256 "47959d0651c32102c10ad919b8a0ffe0ae85f44b8457ddcf2bdc0358fb03dc29"
  end

  # Fixes the unexpected identifier error when compiling software against protobuf:
  # https://github.com/google/protobuf/issues/549
  patch :p1, :DATA

  def install
    # Don't build in debug mode. See:
    # https://github.com/Homebrew/homebrew/issues/9279
    # https://github.com/google/protobuf/blob/e9a122eb19ec54dbca15da80355ed0c17cada9b1/configure.ac#L71-L74
    ENV.prepend "CXXFLAGS", "-DNDEBUG"
    ENV.cxx11 if build.cxx11?

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
           "--prefix=#{prefix}",
           "--with-zlib"
    system "make"
    system "make", "check" if (build.with? "test") || build.bottle?
    system "make", "install"

    # Install editor support and examples
    doc.install "editors", "examples"

    if build.with? "python"
      # google-apputils is a build-time dependency
      ENV.prepend_create_path "PYTHONPATH", buildpath/"homebrew/lib/python2.7/site-packages"
      %w[six python-dateutil pytz python-gflags google-apputils].each do |package|
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

  def caveats; <<~EOS
    Editor support and examples have been installed to:
      #{doc}
    EOS
  end

  test do
    testdata =
      <<~EOS
        package test;
        message TestCase {
          required string name = 4;
        }
        message Test {
          repeated TestCase case = 1;
        }
        EOS
    (testpath/"test.proto").write(testdata)
    system bin/"protoc", "test.proto", "--cpp_out=."
    if build.with? "python"
      protobuf_pth = lib/"python2.7/site-packages/homebrew-protobuf.pth"
      (testpath.realpath/"Library/Python/2.7/lib/python/site-packages").install_symlink protobuf_pth
      system "python", "-c", "import google.protobuf"
    end
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
