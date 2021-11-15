class ProtobufAT36 < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://github.com/protocolbuffers/protobuf/"
  url "https://github.com/protocolbuffers/protobuf/archive/v3.6.1.3.tar.gz"
  sha256 "73fdad358857e120fd0fa19e071a96e15c0f23bb25f85d3f7009abfd4f264a2a"
  license "BSD-3-Clause"
  revision 3

  bottle do
    sha256 cellar: :any, arm64_monterey: "ceeb84f3074f1ca1d3b7e748212f4ec42a9a8287b952723e6acf992eadc20dfc"
    sha256 cellar: :any, arm64_big_sur:  "5d2af02404914b2245a4d464c9d81c93df89c8d6897ba7159831def4f58f42c2"
    sha256 cellar: :any, monterey:       "954a95923217cfd5a5feff68177d6538788667ddb90261a779dda434e9281955"
    sha256 cellar: :any, big_sur:        "e3d0f6755411406d0ce9958c75f0bcdc508cd866d82ab5f098ac21c03470d916"
    sha256 cellar: :any, catalina:       "48adfce2c3ec0a17271946db21810b6d9302aae0d471eab5d17fdae532d4aeea"
    sha256 cellar: :any, mojave:         "5682ac1576b18fb20b6e91d30e99822c66884a9aab048896a3c7297aefe94504"
    sha256 cellar: :any, high_sierra:    "aa953ecc3fcb17999d0cdaa36898ad6700952fae1730f263b2a8e1e090d0faa7"
  end

  keg_only :versioned_formula

  deprecate! date: "2021-02-19", because: :versioned_formula

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "python@3.9"

  resource "six" do
    url "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  resource "gtest" do
    url "https://github.com/google/googletest/archive/release-1.8.1.tar.gz"
    sha256 "9bf1fe5182a604b4135edc1a425ae356c9ad15e9b23f9f12a02e80184c3a249c"
  end

  def install
    (buildpath/"gtest").install resource "gtest"
    (buildpath/"gtest/googletest").cd do
      system "cmake", ".", *std_cmake_args
      system "make"
    end
    ENV["CXXFLAGS"] = "-I../gtest/googletest/include"

    # Don't build in debug mode. See:
    # https://github.com/Homebrew/homebrew/issues/9279
    # https://github.com/protocolbuffers/protobuf/blob/5c24564811c08772d090305be36fae82d8f12bbe/configure.ac#L61
    ENV.prepend "CXXFLAGS", "-DNDEBUG"
    ENV.cxx11

    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-zlib"
    system "make"
    system "make", "install"

    # Install editor support and examples
    pkgshare.install "editors/proto.vim", "examples"
    elisp.install "editors/protobuf-mode.el"

    ENV.append_to_cflags "-I#{include}"
    ENV.append_to_cflags "-L#{lib}"

    resource("six").stage do
      system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(libexec)
    end
    chdir "python" do
      system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(libexec),
                                                      "--cpp_implementation"
    end

    version = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
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
  end
end
