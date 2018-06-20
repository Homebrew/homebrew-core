class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.3.0/protobuf-c-1.3.0.tar.gz"
  sha256 "5dc9ad7a9b889cf7c8ff6bf72215f1874a90260f60ad4f88acf21bb15d2752a1"
  revision 3

  bottle do
    sha256 "8f56aec07a20c79a5d01c7a8d30946d1b86c157d24468e8160edbec318046b71" => :high_sierra
    sha256 "276829169dc5d00b9c14a4542c67009aed3b9049ece5f30aa1bce20bd4f5e195" => :sierra
    sha256 "65e9d6cecfd8cbf6c40cce2a5c16d50c1102a605d1e919c66ca316e7c1046e90" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "protobuf"

  # protobuf 3.6 compat
  # Upstream PR 11 Mar 2018 "Add std:: to some types"
  patch do
    url "https://github.com/protobuf-c/protobuf-c/pull/309.patch?full_index=1"
    sha256 "31aca86f6fd2f99a6dfd0e6ecd46e69db4128709024a33834749f4b1bbbfcaaa"
  end

  # Upstream PR 20 Jun 2018 "Fix build with protobuf 3.6.x"
  patch do
    url "https://github.com/protobuf-c/protobuf-c/pull/328.patch?full_index=1"
    sha256 "a5f66087294eb5cc892985b8edf0114e579a9a1c68c30673f56b508cfce6450a"
  end

  needs :cxx11

  def install
    ENV.cxx11

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
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
