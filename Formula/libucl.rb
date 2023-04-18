class Libucl < Formula
  desc "Universal configuration library parser"
  homepage "https://github.com/vstakhov/libucl"
  url "https://github.com/vstakhov/libucl/archive/0.8.2.tar.gz"
  sha256 "d95a0e2151cc167a0f3e51864fea4e8977a0f4c473faa805269a347f7fb4e165"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f9e944d05b49df899f5b5cf0e655f4f23fc6978abd38e6b420e69f54b2d0b334"
    sha256 cellar: :any,                 arm64_monterey: "09a3e260d36bcdc45e887b82eb7ec003509866fc34d781024bec94577e2e48c2"
    sha256 cellar: :any,                 arm64_big_sur:  "2cb2ecaf50cddcaf11d401e0f9af425ba31b9a39010aaf320421403104445321"
    sha256 cellar: :any,                 ventura:        "247a34b8fdfd55c25c6bb432bf0a99c46a33137491d9073bf64feb5f468ded44"
    sha256 cellar: :any,                 monterey:       "91209890a1a2666cb79822dde2bb7c4914472c145f53019a546271e8845be9f2"
    sha256 cellar: :any,                 big_sur:        "7496b34362a2cab89c43a44f76bacedf44f62835d80f651ab7348c8163b88e4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79b85d68fee133cdc1c58d8b290500e8e6dd8aab787e247e9f4cc2a166b1b0f7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "./autogen.sh"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-utils
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <ucl++.h>
      #include <string>
      #include <cassert>

      int main(int argc, char **argv) {
        const std::string cfg = "foo = bar; section { flag = true; }";
        std::string err;
        auto obj = ucl::Ucl::parse(cfg, err);
        assert(obj);
        assert(obj[std::string("foo")].string_value() == "bar");
        assert(obj[std::string("section")][std::string("flag")].bool_value());
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lucl", "-o", "test"
    system "./test"
  end
end
