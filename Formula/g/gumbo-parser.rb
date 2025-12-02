class GumboParser < Formula
  desc "C99 library for parsing HTML5"
  homepage "https://codeberg.org/gumbo-parser/gumbo-parser"
  url "https://codeberg.org/gumbo-parser/gumbo-parser/archive/0.13.2.tar.gz"
  sha256 "dbdc159dc8e5c6f3f254e50bce689dd9e439064ff06c165d5653410a5714ab66"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c7ea823bbc414304986e981cfc0cb322c6b2ecf13b337645f6a8615284529122"
    sha256 cellar: :any,                 arm64_sequoia: "431e4134fa525f0c69f3ae3ee54bb7213dbbbbbaaa32921eddc0f899811f890d"
    sha256 cellar: :any,                 arm64_sonoma:  "790c2342eda7b07cfcaf46464dea8e376b68f790cb891d6567fb58c840b3e18b"
    sha256 cellar: :any,                 arm64_ventura: "dbd212e34262be85283b0f8f7474bb9420350005de5b751f046d9f788444a381"
    sha256 cellar: :any,                 sonoma:        "dab4d3f868ea634f979bba453ee14b6c3adeaaad533ea6142b6c7fa78417c553"
    sha256 cellar: :any,                 ventura:       "d752c28f0a344934860673f86fcffe5ff578a374731bc66268f7f863a7959d01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42003f370d87b990cea248ab82ceafc3a046a8489711ed9d2518bf974326e36b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "296ea8a9753f6d0e83ab6ac43a6f66309991e27bc65d136ece7e0368993dc066"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "gumbo.h"

      int main() {
        GumboOutput* output = gumbo_parse("<h1>Hello, World!</h1>");
        gumbo_destroy_output(&kGumboDefaultOptions, output);
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lgumbo", "-o", "test"
    system "./test"
  end
end
