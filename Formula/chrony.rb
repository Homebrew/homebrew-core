class Chrony < Formula
  desc "Versatile implementation of the Network Time Protocol (NTP)"
  homepage "https://chrony.tuxfamily.org"
  url "https://download.tuxfamily.org/chrony/chrony-4.2.tar.gz"
  sha256 "273f9fd15c328ed6f3a5f6ba6baec35a421a34a73bb725605329b1712048db9a"
  license "GPL-2.0-only"

  livecheck do
    url "https://chrony.tuxfamily.org/download.html"
    regex(/href=.*?chrony[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb83f99b7e12d8f5ad1b734f2b7566a8c8c866981b6c296dad5d2edec6b12d22"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c8a63cf7644533253ee6b80d5e3b93622a953dd7521f13c2f843ad97a4c63f5"
    sha256 cellar: :any_skip_relocation, monterey:       "9c72a415e288c845f5491f9b8243a5b50a78f6f82afecb458d201968f5de40db"
    sha256 cellar: :any_skip_relocation, big_sur:        "40792ab0bc8e915469e9ec32972b1fc0f829a19daa808fbae999ec56da850040"
    sha256 cellar: :any_skip_relocation, catalina:       "57851e6d80dc3512bb0060c0338b5de0c12ad74d200a0dd7276264c85275f04a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e54104a016acbd42cae4b92ea71ea898ec2b4401858f13894a3c0feca8d12779"
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
