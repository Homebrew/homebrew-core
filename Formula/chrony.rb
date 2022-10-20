class Chrony < Formula
  desc "Versatile implementation of the Network Time Protocol (NTP)"
  homepage "https://chrony.tuxfamily.org"
  url "https://download.tuxfamily.org/chrony/chrony-4.3.tar.gz"
  sha256 "9d0da889a865f089a5a21610ffb6713e3c9438ce303a63b49c2fb6eaff5b8804"
  license "GPL-2.0-only"

  livecheck do
    url "https://chrony.tuxfamily.org/download.html"
    regex(/href=.*?chrony[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a963bb5d33481aa76625c12d7459dcda5aa8383c9c291accbda8107ecf43958"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "976fc7759e22bd69d623525a286a01551dc2d1651a305c053275f41edaa8d3e7"
    sha256 cellar: :any_skip_relocation, monterey:       "a324dd4e43662d3c8b4a362695af02b519838a85273b4fd97b607b22e6e41c9e"
    sha256 cellar: :any_skip_relocation, big_sur:        "71fc7b46b1c4c313b70e72760b8091792fd1670a5a5122020588e6eea2b5244c"
    sha256 cellar: :any_skip_relocation, catalina:       "db8262f30b2074e9e12cc7391de384f4a209dd2cfdbf18f5ac4f189cae61e4fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9bab0617f63d1eda4e8f48316fdf241f9dbac571ddae45608ea58990cfc1f47"
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
