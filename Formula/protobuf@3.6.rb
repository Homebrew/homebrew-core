class ProtobufAT36 < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://github.com/protocolbuffers/protobuf/"
  url "https://github.com/protocolbuffers/protobuf/archive/v3.6.1.3.tar.gz"
  sha256 "73fdad358857e120fd0fa19e071a96e15c0f23bb25f85d3f7009abfd4f264a2a"
  license "BSD-3-Clause"
  revision 4

  bottle do
    sha256 cellar: :any, arm64_monterey: "d11ab752acbd8e1159b2f108ad40d16561823f437e6abe959120500be5513c58"
    sha256 cellar: :any, arm64_big_sur:  "1d9c4d6468e946de5f244b4abe034366e0764f3281d7624db491434e5390a19c"
    sha256 cellar: :any, monterey:       "ee5925f1f3a9dad2c0255e48ac51da352d57145188902c4f285221418bf7a648"
    sha256 cellar: :any, big_sur:        "589ae9de9ebaa86aa06361f03d69389ca86a98d04426b839b5269fa2849861b5"
    sha256 cellar: :any, catalina:       "f05eb7347a6f3912890524a093284a023d0a97a5c283940e8f39e03e5bb60dc5"
  end

  keg_only :versioned_formula

  disable! date: "2022-07-14", because: :versioned_formula

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "python@3.10"

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

    python3 = "python3.10"
    resource("six").stage do
      system Formula["python@3.10"].opt_bin/python3, *Language::Python.setup_install_args(libexec, python3)
    end
    chdir "python" do
      system Formula["python@3.10"].opt_bin/python3, *Language::Python.setup_install_args(libexec, python3),
                                                     "--cpp_implementation"
    end

    site_packages = Language::Python.site_packages(python3)
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
