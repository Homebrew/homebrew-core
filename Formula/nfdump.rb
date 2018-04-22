class Nfdump < Formula
  desc "Tools to collect and process netflow data on the command-line"
  homepage "https://nfdump.sourceforge.io"
  url "https://github.com/phaag/nfdump/archive/v1.6.17.tar.gz"
  sha256 "f71c2c57bdcd0731b2cfecf6d45f9bf57fc7c946858644caf829f738c67c393d"

  bottle do
    cellar :any
    sha256 "8d6bf64877ed6b75bb1cf07e58d3474aba7dba982e3cd5c76c5adf646f1e6782" => :high_sierra
    sha256 "a387e4ffa2c5da2aa4a44fe411fefc9434f888d7f8310e110d10c566f2e61160" => :sierra
    sha256 "8007ce2f9c414dc027fd156a3ef2b2023b16a8c51e3b76ee37a82cca3a96d769" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}", "--enable-readpcap"
    system "make", "install"
  end

  test do
    system bin/"nfdump", "-Z 'host 8.8.8.8'"
  end
end
