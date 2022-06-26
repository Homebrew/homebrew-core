class Pcal < Formula
  desc "Generate Postscript calendars without X"
  homepage "https://pcal.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/pcal/pcal/pcal-4.11.0/pcal-4.11.0.tgz"
  sha256 "8406190e7912082719262b71b63ee31a98face49aa52297db96cc0c970f8d207"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b4a76aed457b08622d910fadeacd998972ed4c16a9c2747fac5c26d4ecfbab4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fdd9d437f60310691c6df93af1ee0bd2cc08e8bae5ee3fa1d73d76b76b4c88e4"
    sha256 cellar: :any_skip_relocation, monterey:       "8b780cbb1c7a72381be2baf453fc7f9f3940aa30e73608928682a2acf6266fab"
    sha256 cellar: :any_skip_relocation, big_sur:        "53c8157fa626298655248853dc283fe15947f47c725de2ea0c934773f0470063"
    sha256 cellar: :any_skip_relocation, catalina:       "9d7f46d2cbf308cd81bcce8fb98e48d295917562a46e509e739cad51d90dcf2c"
    sha256 cellar: :any_skip_relocation, mojave:         "0d4a63fb432c80894e629b89cf5500ffb1a03928b68b0e8c334c96adda01ce2b"
    sha256 cellar: :any_skip_relocation, high_sierra:    "25a667f9b166482637d890497e6fc9465ff8e28a4315a25ba5413fef9c68d79c"
    sha256 cellar: :any_skip_relocation, sierra:         "134df5abc458995e6092041db145e9bca45e2ff71eeeec9de410d497afbe7177"
    sha256 cellar: :any_skip_relocation, el_capitan:     "271667aef1031a0007e042fb3f933708aa33398d6bf9982a7353e6023d0d955c"
    sha256 cellar: :any_skip_relocation, yosemite:       "f88d2fc2ede97fd94333dea90617d02405b008ef359edb694926f4e476c6ae53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4ca61c591e3d9f96352a2b83689f5dad406082f164eeb621602400aed315a9a"
  end

  uses_from_macos "groff" => :build
  uses_from_macos "ncompress" => :build

  def install
    ENV.deparallelize
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    system "make", "install", "BINDIR=#{bin}", "MANDIR=#{man1}",
                              "CATDIR=#{man}/cat1"
  end

  test do
    system "#{bin}/pcal"
  end
end
