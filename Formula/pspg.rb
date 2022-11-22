class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/5.5.12.tar.gz"
  sha256 "8cee0a0cd4aa8a5ce91c11b1d6cb34b87deb71a78a6b25a6993f1af2264957c3"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "203601eec1166b990974b110798cc246eae2699f727a0557f632165c277d256b"
    sha256 cellar: :any,                 arm64_monterey: "0f276a38c8bb134f05067424bc8737626d0335dfe01fb4e013d1ca5963d5ab9d"
    sha256 cellar: :any,                 arm64_big_sur:  "b603db1c81c643463f7adc7be264466c2304c61ca6beadb253179ff4a95b21d8"
    sha256 cellar: :any,                 ventura:        "2439ea7af5c45cac867b21e563dca649bdf1e881e234abe8d6c8d93cd1dc174f"
    sha256 cellar: :any,                 monterey:       "fc33b8fbed32b6c7e71b9a1d7c3ca0bf7709e3e61bbe67ad5821d67287934a6d"
    sha256 cellar: :any,                 big_sur:        "04d7856e8e3f94022abb7b4ab04bd3f261c94feca2b2897f6d568b3dd60d06dd"
    sha256 cellar: :any,                 catalina:       "19266bfea7525ff8bb490b636e12bbc9fb9b9dd4812674e9241e10e28a8d54af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ec24d97dc54439c56fdc1f5cb5d468e07e2caae48ad91264ca17533c8b0baed"
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
    assert_match "pspg-#{version}", shell_output("#{bin}/pspg --version")
  end
end
