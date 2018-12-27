class ProtobufAT31 < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://github.com/protocolbuffers/protobuf/"
  url "https://github.com/protocolbuffers/protobuf/archive/v3.1.0.tar.gz"
  sha256 "fb2a314f4be897491bb2446697be693d489af645cb0e165a85e7e64e07eb134d"

  bottle do
    sha256 "a5fbefb868759d915dbac23e3a5c24def770503e3680ac122299dbaab3bc018d" => :mojave
    sha256 "8648436399064763689f1e39b6c2e7a0ce8d6682064197adb467d7ccc803aa9e" => :high_sierra
    sha256 "941385129ac0e5a34923a373cb57daccfecbaaa25b429624c741873e144ba581" => :sierra
    sha256 "b7d053c5f1dfef00da3c05fd9ad3db7317a8d0abb983290869844d1ef28a799e" => :el_capitan
    sha256 "813126845f50a0d885b9fedb213e566fc5e3d5959f1f69733d8c2d04fa530c67" => :yosemite
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "python@2" # does not support Python 3

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/bd/66/0a7f48a0f3fb1d3a4072bceb5bbd78b1a6de4d801fb7135578e7c7b1f563/appdirs-1.4.0.tar.gz"
    sha256 "8fc245efb4387a4e3e0ac8ebcc704582df7d72ff6a42a53f5600bbb18fdaadc5"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/c6/70/bb32913de251017e266c5114d0a645f262fb10ebc9bf6de894966d124e35/packaging-16.8.tar.gz"
    sha256 "5d50835fdf0a7edf0b55e311b7c887786504efea1177abd7e69329a8e5ea619e"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/38/bb/bf325351dd8ab6eb3c3b7c07c3978f38b2103e2ab48d59726916907cd6fb/pyparsing-2.1.10.tar.gz"
    sha256 "811c3e7b0031021137fc83e051795025fcb98674d07eb8fe922ba4de53d39188"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/64/88/d434873ba1ce02c0ed669f574afeabaeaaeec207929a41b5c1ed947270fc/setuptools-34.1.0.zip"
    sha256 "c0cc0c7d7f86e03b63fd093032890569a944f210358fbfea339252ba33fb1097"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/51/fc/39a3fbde6864942e8bb24c93663734b74e281b984d1b8c4f95d64b0c21f6/python-dateutil-2.6.0.tar.gz"
    sha256 "62a2f8df3d66f878373fd0072eacf4ee52194ba302e00082828e0d263b0418d2"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/d0/e1/aca6ef73a7bd322a7fc73fd99631ee3454d4fc67dc2bee463e2adf6bb3d3/pytz-2016.10.tar.bz2"
    sha256 "7016b2c4fa075c564b81c37a252a5fccf60d8964aa31b7f5eae59aeb594ae02b"
  end

  resource "python-gflags" do
    url "https://files.pythonhosted.org/packages/82/9c/7ed91459f01422d90a734afcf30de7df6b701b90a2e7c7a7d01fd580242d/python-gflags-3.1.0.tar.gz"
    sha256 "3377d9dbeedb99c0325beb1f535f8fa9fa131d1d8b50db7481006f0a4c6919b4"
  end

  resource "google-apputils" do
    url "https://files.pythonhosted.org/packages/69/66/a511c428fef8591c5adfa432a257a333e0d14184b6c5d03f1450827f7fe7/google-apputils-0.4.2.tar.gz"
    sha256 "47959d0651c32102c10ad919b8a0ffe0ae85f44b8457ddcf2bdc0358fb03dc29"
  end

  # Upstream's autogen script fetches this if not present
  # but does no integrity verification & mandates being online to install.
  resource "gmock" do
    url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/googlemock/gmock-1.7.0.zip"
    mirror "https://dl.bintray.com/homebrew/mirror/gmock-1.7.0.zip"
    sha256 "26fcbb5925b74ad5fc8c26b0495dfc96353f4d553492eb97e85a8a6d2f43095b"
  end

  def install
    # Don't build in debug mode. See:
    # https://github.com/Homebrew/homebrew/issues/9279
    # https://github.com/protocolbuffers/protobuf/blob/5c24564811c08772d090305be36fae82d8f12bbe/configure.ac#L61
    ENV.prepend "CXXFLAGS", "-DNDEBUG"

    (buildpath/"gmock").install resource("gmock")
    system "./autogen.sh"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-zlib"
    system "make"
    system "make", "check" if build.bottle?
    system "make", "install"

    # Install editor support and examples
    doc.install "editors", "examples"

    # google-apputils is a build-time dependency
    ENV.prepend_create_path "PYTHONPATH", buildpath/"homebrew/lib/python2.7/site-packages"
    res = resources.map(&:name).to_set - ["gmock"]
    res.each do |package|
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

    protobuf_pth = lib/"python2.7/site-packages/homebrew-protobuf.pth"
    (testpath.realpath/"Library/Python/2.7/lib/python/site-packages").install_symlink protobuf_pth
    system "python2.7", "-c", "import google.protobuf"
  end
end
