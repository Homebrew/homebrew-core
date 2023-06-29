class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.4.1/protobuf-c-1.4.1.tar.gz"
  sha256 "4cc4facd508172f3e0a4d3a8736225d472418aee35b4ad053384b137b220339f"
  license "BSD-2-Clause"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "82563e1d7f8587b0fdd459e26ec2acd3f793c8d126ba35d34767b2a4f810c97d"
    sha256 cellar: :any,                 arm64_monterey: "a5ab5bbf11253c4ee20c196ed13411dff9aa60e3f8bff7748b25d4fb52129ce3"
    sha256 cellar: :any,                 arm64_big_sur:  "41cfec2f4c77c609459bae17cec6ce9911d9fe625f81421f86e57d6ddf286e2a"
    sha256 cellar: :any,                 ventura:        "fa46afc39a500a07b620579512c01e55652349c8263663ff592ab579a0f86a0a"
    sha256 cellar: :any,                 monterey:       "4001f21429c8c39bd4157dcece7fd463912fd45f5fdc2facfdcf51eeaa032e72"
    sha256 cellar: :any,                 big_sur:        "cbffa2432b6f3f6034490020b83139ceb1a957c9ec4286cfee6609676404a129"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6372d245cfdd8fe3e467ce3416c2c3264042e70ca0a341a14d09809dd95c7c64"
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
