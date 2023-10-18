class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.4.1/protobuf-c-1.4.1.tar.gz"
  sha256 "4cc4facd508172f3e0a4d3a8736225d472418aee35b4ad053384b137b220339f"
  license "BSD-2-Clause"
  revision 8

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d4e2f1dc4429a893df2cfc2da5a658d13376c6b83f96ae2c20207a9438d2a4d0"
    sha256 cellar: :any,                 arm64_ventura:  "54d267eb2c007918ab3e712e9c556ca157a5ea99753bbe9f5817427e90f45820"
    sha256 cellar: :any,                 arm64_monterey: "53e5aba64daac0bf347d1be652feb3ccf3b1280d546dfd1cc50a211ac3c97a69"
    sha256 cellar: :any,                 sonoma:         "142c2873aa51ec46d8a3ade0fff18b7773983e31bf1a5cd96d83e380b54e9f6e"
    sha256 cellar: :any,                 ventura:        "ded06834cb6e165df54c71612d09d3cc60907581e70a0255e47e16debd8d5677"
    sha256 cellar: :any,                 monterey:       "10b026444c3da6fc0b4b38a9f46c3078d921393e980d3e0bb28ee9f8eb046b4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b228990cf1f54f2a615841d5eab0f7d1f91027b418e61bc4b821ae7424660d74"
  end

  head do
    url "https://github.com/protobuf-c/protobuf-c.git", branch: "master"
    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # TODO: `autoconf`, `automake`, and `libtool` are needed for the patches.
  #       Remove when they are no longer needed.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "protobuf"

  # The next three patches are for compatibility with the newest protobuf.
  # https://github.com/protobuf-c/protobuf-c/pull/556
  # TODO: Uncomment `if build.head?` in `#install` when these are no longer needed.
  patch do
    url "https://github.com/protobuf-c/protobuf-c/commit/66a0b0d205224f63f19dd8f96abf9dcdc2112331.patch?full_index=1"
    sha256 "a3561ad37f33048c59a1ceece246a515b62cef91126e4041056d10ea26a19230"
  end

  patch do
    url "https://github.com/protobuf-c/protobuf-c/commit/7706c95d4835e75f182ab56d9dad5c8cd8517e0a.patch?full_index=1"
    sha256 "86364b4da6e077bd9f89a82d6e2ac965776ee1a544e43d1964c2e800424cdb6e"
  end

  patch do
    url "https://github.com/protobuf-c/protobuf-c/commit/66574f3fd85a205eb7c90b790477d5415364209e.patch?full_index=1"
    sha256 "2d1d6edbd615dff4f0a9c4a974d325effefc44466e1855f8c0b88e5977962a9d"
  end

  def install
    # https://github.com/protocolbuffers/protobuf/issues/9947
    ENV.append_to_cflags "-DNDEBUG"

    # TODO: Uncomment `if build.head?` when the patches are no longer needed.
    system "autoreconf", "--force", "--install", "--verbose" # if build.head?
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
