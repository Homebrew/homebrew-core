class GumboParser < Formula
  desc "C99 library for parsing HTML5"
  homepage "https://codeberg.org/gumbo-parser/gumbo-parser"
  url "https://codeberg.org/gumbo-parser/gumbo-parser/archive/0.12.1.tar.gz"
  sha256 "c0bb5354e46539680724d638dbea07296b797229a7e965b13305c930ddc10d82"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "1d41ef60b7d141745ea784fcdee5c713be24325ab501af21c494df52fc1a6bda"
    sha256 cellar: :any,                 arm64_sonoma:   "f6a0dabc1c0c428785442f91d630b953ec88c12c1239b2a61f43efa33581ff76"
    sha256 cellar: :any,                 arm64_ventura:  "d1b5fd36b4a97daae20cba972e911d13506cbba81fdcca31dc78868103b55b0c"
    sha256 cellar: :any,                 arm64_monterey: "f22e2d2aed27004de6f03677dc875bcc6c285f5272aeaaf93eaa001c1e5161fe"
    sha256 cellar: :any,                 sonoma:         "0dda2acaa84537db865882b8185a704ab8f8edf39397f19cfbdcacd6df57b852"
    sha256 cellar: :any,                 ventura:        "e84fe4e4c5a0a67c81c18ebdedbf5d983e62785b99b224e9b2a0b6d6bd069ff6"
    sha256 cellar: :any,                 monterey:       "e7eed81ead3d20e44f923ace411a0be2f6560fc56d1f00492f87caa6ceef8c28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "891c8368bbcaeeb7dcc5b78ca4cd4a9efe7c8b570952e13835d2989493fa6922"
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
    (testpath/"test.cpp").write <<~EOS
      #include "gumbo.h"

      int main() {
        GumboOutput* output = gumbo_parse("<h1>Hello, World!</h1>");
        gumbo_destroy_output(&kGumboDefaultOptions, output);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lgumbo", "-o", "test"
    system "./test"
  end
end
