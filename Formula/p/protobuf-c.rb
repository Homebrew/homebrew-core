class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.5.0/protobuf-c-1.5.0.tar.gz"
  sha256 "7b404c63361ed35b3667aec75cc37b54298d56dd2bcf369de3373212cc06fd98"
  license "BSD-2-Clause"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "98050b0cd294095a03a6bee072af444febe085042f7ab6c898613b9918c45e11"
    sha256 cellar: :any,                 arm64_ventura:  "172486be04e173c86bbff62db1427b4031c449b6d060c14ba702fc866257138a"
    sha256 cellar: :any,                 arm64_monterey: "c0b11ff5d79ef93823ce07f054a628eda8ca690500fb7384bf0d2bc292f9d21a"
    sha256 cellar: :any,                 sonoma:         "7cd89b5f3118cc69c668e4111bac42081cdc55e4da2eebe46cf3161527898800"
    sha256 cellar: :any,                 ventura:        "4b9302d5d81ad842cbf0bac78559764bece5234e3c582e3f7411f94cda12eaf9"
    sha256 cellar: :any,                 monterey:       "ff699d5d7e31d24d8a4c729043ed05bd85341910cca98bd52617871fcc3c8c4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13c9b460499e4d272981ee9e2c7cbc74ed0eb0ef6506d1db30c8b950092c9fe3"
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

  # Apply commits from open PR to support Protobuf 26.
  # PR ref: https://github.com/protobuf-c/protobuf-c/pull/711
  patch do
    url "https://github.com/protobuf-c/protobuf-c/commit/e3acc96ca2a00ef715fa2caa659f677cad8a9fa0.patch?full_index=1"
    sha256 "3b564a971023d127bb7b666e5669f792c94766836ccaed5acfae3e23b8152d43"
  end
  patch do
    url "https://github.com/protobuf-c/protobuf-c/commit/1b4b205d87b1bc6f575db1fd1cbbb334a694abe8.patch?full_index=1"
    sha256 "6d02812445a229963add1b41c07bebddc3437fecb2a03844708512326fd70914"
  end
  patch do
    url "https://github.com/protobuf-c/protobuf-c/commit/d95aced22df60a2f0049fc03af48c8b02ce4d474.patch?full_index=1"
    sha256 "7aa44807367a4547bd15b3aa9a5275d5fe4739348bf2741ca773fa47015fb01a"
  end

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
