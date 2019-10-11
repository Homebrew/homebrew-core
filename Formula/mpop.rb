class Mpop < Formula
  desc "POP3 client"
  homepage "https://marlam.de/mpop/"
  url "https://marlam.de/mpop/releases/mpop-1.4.5.tar.xz"
  sha256 "5b69723b216d4330b93af81b487952e5897dcde782e3be65a4e79c87e420c7d4"

  bottle do
    rebuild 1
    sha256 "d7c6e864441dbdeba735ead1fb4c3596678681ca3dcbbe509255c92b8164aa1d" => :catalina
    sha256 "e47884232dea498017d9963d255d62156e320413343b8d88994308f6c3cddd36" => :mojave
    sha256 "03dbb2545823fc038d3b0664aa09c33f7ccc6e77f63c79701856f5336d01a4e9" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mpop --version")
  end
end
