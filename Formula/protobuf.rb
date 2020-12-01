class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://github.com/protocolbuffers/protobuf/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v3.14.0/protobuf-all-3.14.0.tar.gz"
  sha256 "6dd0f6b20094910fbb7f1f7908688df01af2d4f6c5c21331b9f636048674aebf"
  license "BSD-3-Clause"

  livecheck do
    url "https://github.com/protocolbuffers/protobuf/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "f41381ba1643de583cd742e491d5701cd206625783825684eb3506c62bcf997c" => :big_sur
    sha256 "7674ca66757bd1249545829c3ae6f254518b5e75b81e12fdc26c9b56a48fc299" => :catalina
    sha256 "db7a01c58842fea34251f5b27af0b9cbc2c3208325180a7e9b7330e7ec659161" => :mojave
  end

  head do
    url "https://github.com/protocolbuffers/protobuf.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "python@3.9" => [:build, :test]

  conflicts_with "percona-server", "percona-xtrabackup",
    because: "both install libprotobuf(-lite) libraries"

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  def install
    # Don't build in debug mode. See:
    # https://github.com/Homebrew/homebrew/issues/9279
    # https://github.com/protocolbuffers/protobuf/blob/5c24564811c08772d090305be36fae82d8f12bbe/configure.ac#L61
    ENV.prepend "CXXFLAGS", "-DNDEBUG"
    ENV.cxx11

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-zlib"
    system "make"
    system "make", "check"
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
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import google.protobuf"
  end
end
