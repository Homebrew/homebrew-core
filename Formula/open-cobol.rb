class OpenCobol < Formula
  desc "COBOL compiler"
  # Canonical domain: opencobol.org
  homepage "https://sourceforge.net/projects/open-cobol/"
  url "https://downloads.sourceforge.net/project/open-cobol/open-cobol/1.1/open-cobol-1.1.tar.gz"
  sha256 "6ae7c02eb8622c4ad55097990e9b1688a151254407943f246631d02655aec320"
  revision 1

  bottle do
    sha256 "49f1746940e7d385f976c594517d4c87263bbdf216ab82dfd42f79b8d2a24e96" => :high_sierra
    sha256 "2ef0f1a0ed50e42ae2c25ae9281fe02e35a4b29b56800a79b38271b74004bb9a" => :sierra
    sha256 "79c04c9fece60fcca728d408298e521679051e493a84907e0112638009616f8a" => :el_capitan
    sha256 "4df237883c76c8d8566a3a44f7d77bc9820f2ef027392d20f31afe7601050625" => :yosemite
  end

  depends_on "gmp"
  depends_on "berkeley-db"

  conflicts_with "gnu-cobol",
    :because => "both install `cob-config`, `cobc` and `cobcrun` binaries"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--infodir=#{info}"
    system "make", "install"
  end

  test do
    system "#{bin}/cobc", "--help"
  end
end
