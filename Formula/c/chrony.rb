class Chrony < Formula
  desc "Versatile implementation of the Network Time Protocol (NTP)"
  homepage "https://chrony-project.org"
  url "https://chrony-project.org/releases/chrony-4.9.tar.gz"
  sha256 "4924c6f530105bcd5b9e9e33c48a2ae1bfd889222c8480bc41601110efc864d0"
  license "GPL-2.0-only"

  livecheck do
    url "https://chrony-project.org/download.html"
    regex(/href=.*?chrony[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "56089ce68a07826e7b4c4fb52b15b1dac275b771001e45d02437186d52dde80f"
    sha256 cellar: :any, arm64_tahoe:       "a1df029e9d933dd0dcce82a8b260475751ff01eeb68767b8362735a7c88c923d"
    sha256 cellar: :any, arm64_sequoia:     "5e74476cc6557b1240bea6d5aefe3aecede3148be44375fc1120de2dc03122cb"
    sha256 cellar: :any, arm64_sonoma:      "11ceb839ac6aef7f962b23917fdab498e2e9d6db5258f1a7f011c77ac96345c1"
    sha256 cellar: :any, arm64_linux:       "f55ea3c6e4a3474107db301c1f50b0c054a3eb09a3d69fc987d5fcabbcb6412c"
    sha256 cellar: :any, x86_64_linux:      "2cacbc292c5a1c7bd20bde5ecb8e4075cce843952bd24ac5418127e4a66d6076"
  end

  depends_on "pkgconf" => :build
  depends_on "gnutls"
  depends_on "nettle"

  uses_from_macos "libedit"

  def install
    system "./configure", "--localstatedir=#{var}", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.conf").write "pool pool.ntp.org iburst\n"
    output = shell_output("#{sbin}/chronyd -Q -f #{testpath}/test.conf 2>&1")
    assert_match(/System clock wrong by -?\d+\.\d+ seconds \(ignored\)/, output)
  end
end
