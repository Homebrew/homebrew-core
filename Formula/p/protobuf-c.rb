class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.4.1/protobuf-c-1.4.1.tar.gz"
  sha256 "4cc4facd508172f3e0a4d3a8736225d472418aee35b4ad053384b137b220339f"
  license "BSD-2-Clause"
  revision 7

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c22945177efec85a4b167ab364a46d374b22154b3eab165aff689101d6267ce1"
    sha256 cellar: :any,                 arm64_ventura:  "37a4bccd649b2435c9c6d5d97052bedd166c6c0de7580360d6c10bd19dcbf930"
    sha256 cellar: :any,                 arm64_monterey: "c45b43b82dc7043bebec4bd0a4bcdb7e6f58b64f5495182d5530fb0571d02d2e"
    sha256 cellar: :any,                 arm64_big_sur:  "392fb3edc430d2372b401b50fa09c85347f09c393b60c905647aec7214f5f5cd"
    sha256 cellar: :any,                 sonoma:         "1c194b43acd1c81c2f682ddd0ad537f5bcb9d19b0d2c1b566c7b208637b65faf"
    sha256 cellar: :any,                 ventura:        "40b6341261f223df456dafb7166367b7c4d007749e4e06dfff186d6537c5e290"
    sha256 cellar: :any,                 monterey:       "66f3cd044e6b8dd0cd558a3342092657b2d0d96864f08a0f1cacbba0912e06d6"
    sha256 cellar: :any,                 big_sur:        "d10693cc22348eea4be40236f6113f6ef5b2d217316da61fc762a89aaf7fa400"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f681a4ef1578ca632766037b520ec9f90eab975351ef00e45f1dd60b1e4afc7"
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
