class Chrony < Formula
  desc "Versatile implementation of the Network Time Protocol (NTP)"
  homepage "https://chrony.tuxfamily.org"
  url "https://download.tuxfamily.org/chrony/chrony-4.1.tar.gz"
  sha256 "ed76f2d3f9347ac6221a91ad4bd553dd0565ac188cd7490d0801d08f7171164c"
  license "GPL-2.0-only"

  livecheck do
    url "https://chrony.tuxfamily.org/download.html"
    regex(/href=.*?chrony[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "089aa389bea9d6408b8e3f8e681af3648b37b2d5a6245fcebbe15fbf0c2dea93"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "90fcce18cd0b68629e37023124cb961ac67c2f36da2bdfaeeeb2f6b146a49b9c"
    sha256 cellar: :any_skip_relocation, monterey:       "4c45d8bb188a7b081c14ad95e166ed201690104817b09385b3a1d3c2ecbd7c07"
    sha256 cellar: :any_skip_relocation, big_sur:        "ecba024c1c74b0f2d8094b06043a6ceafbc4bcd4cba944e3600792789adcfb4b"
    sha256 cellar: :any_skip_relocation, catalina:       "dfe728a9f5ecc085ba6582a2791e1e6a2f5d2ef609ee4f3da237e4442d016dbe"
    sha256 cellar: :any_skip_relocation, mojave:         "b908fae19168cb50d7d1fe33e2885ad19ff8bb1e190442aa3ee6ea6c47f4c72f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7f08010b437e23b4debb9f0d278adf3eb84972a6810f2cb6daa0b81077084cc"
  end

  depends_on "nettle"

  uses_from_macos "libedit"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}"
    system "make", "install"
  end

  test do
    (testpath/"test.conf").write "pool pool.ntp.org iburst\n"
    output = shell_output(sbin/"chronyd -Q -f #{testpath}/test.conf 2>&1")
    assert_match(/System clock wrong by -?\d+\.\d+ seconds \(ignored\)/, output)
  end
end
