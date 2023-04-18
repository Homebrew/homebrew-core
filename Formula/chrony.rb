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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7389868d80c6347b733de4a862b3c86d07346f5a4c3e77e43363054d2375f873"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38eb54ef554174b1f562816af11062da89a4d6ec0ae36d8a93e80eccfc09e8ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "976fc7759e22bd69d623525a286a01551dc2d1651a305c053275f41edaa8d3e7"
    sha256 cellar: :any_skip_relocation, ventura:        "199619c582ec05bdc58cf02fb4104a2d68083572a31731ad6f66f4cb69829003"
    sha256 cellar: :any_skip_relocation, monterey:       "e67ca9f1e1546aeccad2d8849ac0f113f20176c7b496ca82e72f79f69f33f6a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "71fc7b46b1c4c313b70e72760b8091792fd1670a5a5122020588e6eea2b5244c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c63c56febf06ef070ebe631eed1f5aef8252636ac2fe6945b7dd0b0b09b9f1b"
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
