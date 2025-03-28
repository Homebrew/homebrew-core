class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.5.1/protobuf-c-1.5.1.tar.gz"
  sha256 "20d1dc257da96f8ddff8be4dd9779215bbd0a6069ed53bbe9de38fa7629be06b"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "446715f1e5c9c96bcbac59e1e4f5744c6ac29b72e17f01c0440cac3badc1f4bd"
    sha256 cellar: :any,                 arm64_sonoma:  "8ae30fa7cf6e99f3fbfd668e674d03a2c7e37a7cf1220f033df668c0b2c22573"
    sha256 cellar: :any,                 arm64_ventura: "fabc965b14258983dfa5b10485661faed63954430a2264cbbba5ea7fa2726ff7"
    sha256 cellar: :any,                 sonoma:        "f79f20f93a46402bbef5efabd202cbf8bb9056e8ca59a5fc7dcdfeeb6a4cc8c6"
    sha256 cellar: :any,                 ventura:       "ee5ce24a79f4602cee1f23e4c60aff63f18023a02ee118d21bc1e4e3f23ff089"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e32a2f37aa224700668eba254ce9e0144e78f6ecbf162881c82508769bf74947"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddcd7687f0010b40c304dde7d099395d509b9fac55638e41aaa159f0ef795893"
  end

  head do
    url "https://github.com/protobuf-c/protobuf-c.git", branch: "master"

    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "protobuf"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    testdata = <<~PROTO
      syntax = "proto3";
      package test;
      message TestCase {
        string name = 4;
      }
      message Test {
        repeated TestCase case = 1;
      }
    PROTO
    (testpath/"test.proto").write testdata
    system Formula["protobuf"].opt_bin/"protoc", "test.proto", "--c_out=."

    testpath.glob("test.pb-c.*").map(&:unlink)
    system bin/"protoc-c", "test.proto", "--c_out=."
  end
end
