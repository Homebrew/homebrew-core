class MscGenerator < Formula
  desc "Draws signalling charts from textual description"
  homepage "https://sourceforge.net/p/msc-generator"
  url "https://downloads.sourceforge.net/project/msc-generator/msc-generator/v6.x/msc-generator-6.3.10.tar.gz"
  sha256 "0ed111f00d3638774458fc4fe48314f1223b2c85233d5ed3a8dd3bfbaafdb1f8"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "c26637f30249c3307c8da6d8cb0b74912084d738b8adb809f25f1433127ef634"
    sha256 cellar: :any, big_sur:       "2d2550736b6a08b3a4dd2ab633d83bb97c61e90fff3320f59533a256663e2a01"
    sha256 cellar: :any, catalina:      "5c495074651edf5843b55d27a050b4ed0e105826437117761c386a0bf0c51e55"
    sha256 cellar: :any, mojave:        "8f0f5c54980b9eb4eb308ba3c62439f7eadb5db52f902802c594a72ca34b43f4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "glpk"
  depends_on "graphviz"

  def install
    system "./configure", "--prefix=#{prefix}"
    # Dance around upstream trying to build everything in doc/ which we don't do for now
    # system "make", "install"
    system "make", "-C", "src", "install"
    system "make", "-C", "doc", "msc-gen.1"
    man1.install "doc/msc-gen.1"
  end

  test do
    # Try running the program
    system "#{bin}/msc-gen", "--version"
    # Construct a simple chart and check if PNG is generated (the default output format)
    (testpath/"simple.signalling").write("a->b;")
    system "#{bin}/msc-gen", "simple.signalling"
    assert_predicate testpath/"simple.png", :exist?
    bytes = File.open(testpath/"simple.png", "rb").read
    assert_equal bytes[0..7], "\x89PNG\r\n\x1a\n".force_encoding("ASCII-8BIT")
  end
end
