class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.5.0/protobuf-c-1.5.0.tar.gz"
  sha256 "7b404c63361ed35b3667aec75cc37b54298d56dd2bcf369de3373212cc06fd98"
  license "BSD-2-Clause"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "df5af8a9c04252f1fcac98ea4fde53bc8155a744ab43fbd468054a437ebae1bc"
    sha256 cellar: :any,                 arm64_ventura:  "ebd9845213d039d4b28abb920ea1901409027a0b43089c7d880f81cdb5d4268a"
    sha256 cellar: :any,                 arm64_monterey: "e3d6422ed4907887866f9156d4521f4b115282f392c0ec0f1503e3179f2ae28b"
    sha256 cellar: :any,                 sonoma:         "b7e1f5a5faae8ec2883d8f15ae7dac90947598e0e09c453baadc2434d617cdad"
    sha256 cellar: :any,                 ventura:        "10b6937dbbf598df70e2476bbe897ea711d1774875b412d95c80b2a5543b42d2"
    sha256 cellar: :any,                 monterey:       "cc9e1f7714ed441a06ff02ec00c6743da4cdc58297f6995f6db564c787b91a40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b378ec485821b3c498a553fd0f2a26720b87472196cea9285eed6ba8088a0da"
  end

  head do
    url "https://github.com/protobuf-c/protobuf-c.git", branch: "master"
    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "protobuf"

  def install
    # https://github.com/protocolbuffers/protobuf/issues/9947
    ENV.append_to_cflags "-DNDEBUG"

    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
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
    system Formula["protobuf"].opt_bin/"protoc", "test.proto", "--c_out=."
  end
end
