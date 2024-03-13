class Chrony < Formula
  desc "Versatile implementation of the Network Time Protocol (NTP)"
  homepage "https://chrony-project.org"
  url "https://chrony-project.org/releases/chrony-4.5.tar.gz"
  sha256 "19fe1d9f4664d445a69a96c71e8fdb60bcd8df24c73d1386e02287f7366ad422"
  license "GPL-2.0-only"

  livecheck do
    url "https://chrony-project.org/download.html"
    regex(/href=.*?chrony[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "47ebf8f7344e63f305e91ef47109ce7cc2aa80c4161b6fd8dac72d1cbf31f7c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4994b90406029f34204bb3054e4cf68b3eb06b3182e2461076612274db8ad0f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03f395c840e097380dd58718c16157a35edc0bfa7beb34b43754e2d0915bbe15"
    sha256 cellar: :any_skip_relocation, sonoma:         "f3fbf6340640302d181354813d3fb4fea3a2036e6909a1a54a7a70a37966190c"
    sha256 cellar: :any_skip_relocation, ventura:        "43b22abad1f05d76255630567df0636902021a0588f2c58f0bed532a7996eb2f"
    sha256 cellar: :any_skip_relocation, monterey:       "27264818aa759d9655b218f0c8a3ff8ae916b2374712fb3e9d5b8ee42330a5c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52eb2a90d0a86c0259c2bf09ae9474262adb420c5bc6dd75ecb0ff8b5124f1c9"
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "nettle"

  uses_from_macos "libedit"

  def install
    system "./configure", "--localstatedir=#{var}", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.conf").write "pool pool.ntp.org iburst\n"
    output = shell_output(sbin/"chronyd -Q -f #{testpath}/test.conf 2>&1")
    assert_match(/System clock wrong by -?\d+\.\d+ seconds \(ignored\)/, output)
  end
end
