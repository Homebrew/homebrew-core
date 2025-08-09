class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.5.2/protobuf-c-1.5.2.tar.gz"
  sha256 "e2c86271873a79c92b58fef7ebf8de1aa0df4738347a8bd5d4e65a80a16d0d24"
  license "BSD-2-Clause"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8e83f77a082a599c5214eb36784c28ead28888e93b67ce81a74d675efee24e56"
    sha256 cellar: :any,                 arm64_sonoma:  "c84ed0bff05454ba891117c2f27eee7fe878eec792ab72176597c524770c4846"
    sha256 cellar: :any,                 arm64_ventura: "38ae66e6b2407b36de588dbb3d978c6175719b16b20725bbaf517070cc40592a"
    sha256 cellar: :any,                 sonoma:        "5d8f1712d6a6421f70b562945a296059e8645b8532b4994785d0ea06eb213638"
    sha256 cellar: :any,                 ventura:       "f8c32fc2ce0484501367ea15ba9caf0f66366dd0e8f2a2446a7b978a8645478d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79d805961a64bc2d8b7d6eed3d08edf4a9806cf5d3ccbb8322d9cbec055d544c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24e019e3ac05d606e1b17d1e85b83f3ffa8300c8c27e0898d22431390e51511c"
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
