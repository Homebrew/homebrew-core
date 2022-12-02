class Compface < Formula
  desc "Convert to and from the X-Face format"
  homepage "https://web.archive.org/web/20170720045032/freecode.com/projects/compface"
  url "https://mirrorservice.org/sites/ftp.xemacs.org/pub/xemacs/aux/compface-1.5.2.tar.gz"
  mirror "https://ftp.heanet.ie/mirrors/ftp.xemacs.org/aux/compface-1.5.2.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/compface/compface-1.5.2.tar.gz"
  sha256 "a6998245f530217b800f33e01656be8d1f0445632295afa100e5c1611e4f6825"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "830980257b29d4636b176c027dd06d5b3f764caf5c80019462ff0433206bd948"
    sha256 cellar: :any_skip_relocation, big_sur:       "47627a5cff1cda824fd58ae597453a14e22fa66355ff0ee1032b462159e2173b"
    sha256 cellar: :any_skip_relocation, catalina:      "1d05066e7342782014477a515bdb108bc4eb279cba1b8a5623ebc371c5165c16"
    sha256 cellar: :any_skip_relocation, mojave:        "10d7c5d38196576ac2d21278ead512819c9e393fa8caf81d75a70d7b09c7aaa8"
    sha256 cellar: :any_skip_relocation, high_sierra:   "15f3ed9a165fa2f4966fde4de5b8b1c62d583425e0c3d9961b26348f6355bfcc"
    sha256 cellar: :any_skip_relocation, sierra:        "092d90367b0fa75ff8a1be3982cda127226fb9805c681170f66fe27c148c8d1b"
    sha256 cellar: :any_skip_relocation, el_capitan:    "50200eb6f7cb61be39420d2e127eb4e2af9391a514f7cfbd26fa9203ca137d21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "757cabab0597a55c8429031e4349fea9acd4c2d2ad576640aba11d80a1652bff"
  end

  deprecate! date: "2022-12-02", because: :unmaintained

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"

    system "make", "install"
  end

  test do
    system bin/"uncompface"
  end
end
