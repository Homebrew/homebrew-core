class Fondu < Formula
  desc "Tools to convert between different font formats"
  homepage "https://fondu.sourceforge.io/"
  url "https://fondu.sourceforge.io/fondu_src-060102.tgz"
  sha256 "22bb535d670ebc1766b602d804bebe7e84f907c219734e6a955fcbd414ce5794"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "475674b5832a56db833ddf7fd01a4c16ff848dfc43dcca726ddfca86d42afdec" => :mojave
    sha256 "00619e7b8f11378041a50cfcb557bebdfb542fbd7f1d5eda85d756537b9c34d9" => :high_sierra
    sha256 "a4e10488264a8c28c06aa2f517e1937b3375462b4c44dcfb2ed50a8742298821" => :sierra
    sha256 "c4fadd6744370dc946b7dde1ec8329335146257ad60b829f9f4024912859d7db" => :el_capitan
    sha256 "dfeddb29a48dcf4db6aaf8170b54137fb329e216a4f83f47ddf262a984ab469e" => :yosemite
    sha256 "cc8bb3c5213b0b792929fa1658077da60717993f0dbdaa56c0fe6004930309f4" => :mavericks
  end

  conflicts_with "cspice", :because => "both install `tobin` binaries"

  resource "cminch.ttf" do
    url "http://mirrors.ctan.org/fonts/cm/ps-type1/bakoma/ttf/cminch.ttf"
    mirror "https://ftp.gnome.org/mirror/CTAN/fonts/cm/ps-type1/bakoma/ttf/cminch.ttf"
    sha256 "03aacbe19eac7d117019b6a6bf05197086f9de1a63cb4140ff830c40efebac63"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--exec-prefix=#{prefix}"
    system "make", "install"
    man1.install Dir["*.1"]
  end

  test do
    resource("cminch.ttf").stage do
      system "#{bin}/ufond", "cminch.ttf"
    end
  end
end
