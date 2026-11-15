class Minidjvu < Formula
  desc "DjVu multipage encoder, single page encoder/decoder"
  homepage "https://minidjvu.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/minidjvu/minidjvu/0.8/minidjvu-0.8.tar.gz"
  sha256 "e9c892e0272ee4e560eaa2dbd16b40719b9797a1fa2749efeb6622f388dfb74a"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/minidjvu[._-]v?((?!0\.33)\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "281b013a773e8ecbd20ce404552b3b052e7bd7769c407e2586e550ded44f6ca3"
    sha256 cellar: :any, arm64_tahoe:       "344f5764c5d83cb418143496312da7c9db8d17ca04b2f044e329ff5dbb450945"
    sha256 cellar: :any, arm64_sequoia:     "ce4a9e99a9b3148e38073ec4d59bb065d09a3c00bd39cc664269f05e2b10059a"
    sha256 cellar: :any, arm64_linux:       "69437755c726adf7540b08341a7dedfb6f1fb34edb07497c6e26c8d7f10a6ed0"
    sha256 cellar: :any, x86_64_linux:      "b3d4785e9d16ae0362c46d350bf6b00d38e88c7404289e145fc36f9d08f38c91"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "djvulibre"
  depends_on "libtiff"

  on_linux do
    depends_on "gzip"
  end

  deny_network_access!

  def install
    inreplace "Makefile.in", "/usr/bin/gzip", formula_opt_bin("gzip")/"gzip" unless OS.mac?

    ENV.deparallelize
    # force detection of BSD mkdir (macos)
    # outdated configure scripts fail to detect the correct build type (linux arm)
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
    lib.install Dir[prefix/shared_library("*")]
  end

  test do
    circle = (0...16).map { |y| (0...16).map { |x| ((((x - 8)**2) + ((y - 8)**2)) < 25) ? 1 : 0 }.join }
    box = (0...16).map { |y| (0...16).map { |x| (x.between?(3, 12) && y.between?(3, 12)) ? 1 : 0 }.join }
    (testpath/"circle.pbm").binwrite "P4\n16 16\n#{[circle.join].pack("B*")}"
    (testpath/"box.pbm").binwrite "P4\n16 16\n#{[box.join].pack("B*")}"

    # Encode a bundled multipage document and decode it back with djvulibre
    system bin/"minidjvu", "circle.pbm", "box.pbm", "out.djvu"
    assert_equal "AT&TFORM", (testpath/"out.djvu").binread(8)

    djvulibre = formula_opt_bin("djvulibre")
    assert_equal "2", shell_output("#{djvulibre}/djvused -e n out.djvu").strip
    system djvulibre/"ddjvu", "-format=pbm", "-page=1", "out.djvu", "page1.pbm"
    system djvulibre/"ddjvu", "-format=pbm", "-page=2", "out.djvu", "page2.pbm"
    assert_equal (testpath/"circle.pbm").binread, (testpath/"page1.pbm").binread
    assert_equal (testpath/"box.pbm").binread, (testpath/"page2.pbm").binread
  end
end
