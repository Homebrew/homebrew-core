class ProtobufAT26 < Formula
  desc "Protocol buffers - Google data interchange format"
  homepage "https://github.com/protocolbuffers/protobuf/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v2.6.1/protobuf-2.6.1.tar.bz2"
  sha256 "ee445612d544d885ae240ffbcbf9267faa9f593b7b101f21d58beceb92661910"

  bottle do
    sha256 "0c9e16290618523a67f58df3ef0ab7690ae86bafc74fead2ad199840e30ca57b" => :mojave
    sha256 "1ceb82b9eea2e86848d959bab4d5468b9388c45b7d687330cc709a11d591f893" => :high_sierra
    sha256 "c3a17e095f0bba62fc1dc9a84adf830b4ab9d1198ec497c8bb2575fde97b5d30" => :sierra
    sha256 "e1bf141c14c28ea10aec3cde34d228facbe0082c40dbb69d4d997b7103b72662" => :el_capitan
  end

  keg_only :versioned_formula

  option "without-python@2", "Build without python2 support"
  option :cxx11

  deprecated_option "without-python" => "without-python@2"

  depends_on "python@2" => :recommended

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
  # https://github.com/protocolbuffers/protobuf/issues/549
  patch :p1, :DATA

  def install
    # Don't build in debug mode. See:
    # https://github.com/Homebrew/homebrew/issues/9279
    # https://github.com/protocolbuffers/protobuf/blob/e9a122eb19ec54dbca15da80355ed0c17cada9b1/configure.ac#L71-L74
    ENV.prepend "CXXFLAGS", "-DNDEBUG"
    ENV.cxx11 if build.cxx11?

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
           "--prefix=#{prefix}",
           "--with-zlib"
    system "make"
    system "make", "check" if build.bottle?
    system "make", "install"

    # Install editor support and examples
    doc.install "editors", "examples"

    if build.with? "python@2"
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
    if build.with? "python@2"
      protobuf_pth = lib/"python2.7/site-packages/homebrew-protobuf.pth"
      (testpath.realpath/"Library/Python/2.7/lib/python/site-packages").install_symlink protobuf_pth
      system "python2.7", "-c", "import google.protobuf"
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
