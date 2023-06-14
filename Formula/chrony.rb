class Chrony < Formula
  desc "Versatile implementation of the Network Time Protocol (NTP)"
  homepage "https://chrony.tuxfamily.org"
  url "https://download.tuxfamily.org/chrony/chrony-4.3.tar.gz"
  sha256 "9d0da889a865f089a5a21610ffb6713e3c9438ce303a63b49c2fb6eaff5b8804"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url "https://chrony.tuxfamily.org/download.html"
    regex(/href=.*?chrony[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88e2454307944b9e285480b943964de23851b0fae1717e250f061e521bf18fe5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "451d968c15da421fb5ddc27c4f0551fbabff228d5acd3220826d2f80dddcfa34"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ffbb300f8de033449878b4c19a44f8b37b8885c9a9fa362210b755b4c75e519"
    sha256 cellar: :any_skip_relocation, ventura:        "38479adf9a253a0f1b3354bb39b169237107a792a99c29e5d32671af6751ae64"
    sha256 cellar: :any_skip_relocation, monterey:       "839c1232ef4dcb274ac537395706c29de8151afec218136d084c00cbcd6af95b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac419164fd20ef6a925333ee5358ac146d469c62e29e51a7a98871b5f7d45914"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0dc242aba927d01713694aefeab587003e3946fb3bfefaefbb858d058edb489"
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
