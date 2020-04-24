class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/3.0.7.tar.gz"
  sha256 "10d82c4b0112e51d397ea8f70c973c6d085aa964381ecc950a1cd8a7b4af72da"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "586f9209acd2acc43f599c8d467d633600ea46bfeef3c5de93bbc88fd9f49f96" => :catalina
    sha256 "0f13f6316c8752c65821ee1f4d02e927cd27e4616ebd22ff3c2d31ff000874d1" => :mojave
    sha256 "79ded916b55efc28d60681eb8a29de793b9276ec7692f8f6b4a85944a796f66a" => :high_sierra
  end

  depends_on "libpq"
  depends_on "ncurses"
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      Add the following line to your psql profile (e.g. ~/.psqlrc)
        \\setenv PAGER pspg
        \\pset border 2
        \\pset linestyle unicode
    EOS
  end

  test do
    assert_match "pspg-#{version.to_f}", shell_output("#{bin}/pspg --version", 1)
  end
end
