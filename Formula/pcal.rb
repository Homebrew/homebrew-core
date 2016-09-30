class Pcal < Formula
  desc "Generate Postscript calendars without X"
  homepage "http://pcal.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/pcal/pcal/pcal-4.11.0/pcal-4.11.0.tgz"
  sha256 "8406190e7912082719262b71b63ee31a98face49aa52297db96cc0c970f8d207"

  bottle do
    cellar :any_skip_relocation
    sha256 "134df5abc458995e6092041db145e9bca45e2ff71eeeec9de410d497afbe7177" => :sierra
    sha256 "271667aef1031a0007e042fb3f933708aa33398d6bf9982a7353e6023d0d955c" => :el_capitan
    sha256 "f88d2fc2ede97fd94333dea90617d02405b008ef359edb694926f4e476c6ae53" => :yosemite
    sha256 "b0662dd7e1841adf260b267fa8f9187c60c87c7b7c07075e6179cdabd230e2bd" => :mavericks
  end

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
