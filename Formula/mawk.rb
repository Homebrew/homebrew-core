class Mawk < Formula
  desc "Interpreter for the AWK Programming Language"
  homepage "http://invisible-island.net/mawk/"
  url "ftp://invisible-island.net/mawk/mawk-1.3.4-20160615.tgz"
  sha256 "230a2a2c707e184eb7e56681b993862ab0c4ed2165a893df4e96fac61e7813ac"

  bottle do
    cellar :any_skip_relocation
    sha256 "e72485ccf8ad368a24ed2368c3ae540cd2762673ed2dcee7ae2b6b0f10cbbedf" => :sierra
    sha256 "a4d717ff92ddbddbd1dd85a817d84309466e620ca3c7a13279eaaf8a81700909" => :el_capitan
    sha256 "8e5157976cb4dfdd2da2ffb3a7367a881fe95967fe33d36e7489ed4a933e0a84" => :yosemite
    sha256 "ee73fb357d5cdc4c3f1e01c91f3efd2bf0397f6b00e3e265a1cb565f6d251256" => :mavericks
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-silent-rules",
                          "--with-readline=/usr/lib",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    version = shell_output("#{bin}/mawk '/version/ { print $2 }' #{prefix}/README")
    assert_equal version, version.to_s
  end
end
