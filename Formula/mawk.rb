class Mawk < Formula
  desc "Interpreter for the AWK Programming Language"
  homepage "http://invisible-island.net/mawk/"
  url "ftp://invisible-island.net/pub/mawk/mawk-1.3.4-20161120.tgz"
  sha256 "361ec1bb4968c1f1f3b91b77493cf11b31c73ff8516f95db30e4dc28de180c1e"

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
    mawk_expr = '/^mawk / {printf("%s-%s", $2, $3)}'
    ver_out = shell_output("#{bin}/mawk -W version 2>&1 | #{bin}/mawk '#{mawk_expr}'")
    assert_equal version.to_s, ver_out
  end
end
