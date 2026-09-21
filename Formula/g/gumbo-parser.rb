class GumboParser < Formula
  desc "C99 library for parsing HTML5"
  homepage "https://codeberg.org/gumbo-parser/gumbo-parser"
  url "https://codeberg.org/gumbo-parser/gumbo-parser/archive/0.14.0.tar.gz"
  sha256 "eac82480b916d520e4c7938cbd593ceda34c9241cba04022a078550d0d324cfe"
  license "Apache-2.0"
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3b00b08e1c68226c21c327e1dc2e622c6807602a7245340ccc92bf7c50b05ec2"
    sha256 cellar: :any, arm64_tahoe:       "aeb97dc8e078af3ca64411c25764f720da99caa323eecac8b03977e120093dc7"
    sha256 cellar: :any, arm64_sequoia:     "c5912aa60532919751ec4b2ab685d3528c93307893d3cf8e9769f96d8fb95062"
    sha256 cellar: :any, arm64_sonoma:      "2e1ef3ac6dab8b652948b93cedb24cce0c9d63aebcd7e91091b62cf83ec3f981"
    sha256 cellar: :any, arm64_linux:       "3559d483ddc898a201c1be70e9a2da4eb5116537badd05dbfcd4c45c01774501"
    sha256 cellar: :any, x86_64_linux:      "964e6729f73031fee018819b1f746092bfa6b33c64aaaf2a864981f653374ce9"
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
