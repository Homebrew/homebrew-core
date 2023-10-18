class Chrony < Formula
  desc "Versatile implementation of the Network Time Protocol (NTP)"
  homepage "https://chrony-project.org"
  url "https://chrony-project.org/releases/chrony-4.4.tar.gz"
  sha256 "eafb07e6daf92b142200f478856dfed6efc9ea2d146eeded5edcb09b93127088"
  license "GPL-2.0-only"

  livecheck do
    url "https://chrony-project.org/download.html"
    regex(/href=.*?chrony[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fee2403905bacfa6db6342781141d755d688d1e3f36dfd4a1b48ef90d31a6470"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cfb99fd7b217e10e1d9ae7690c40e7f863fc6f42111b35ddc1b601a92827df5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8b3a86682971e2294dc86510f9a51b5537bc32010d1537c05f2f1b51f6e1e2d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4261a28c36662da557d8e52b70a25948f8096b0ba29f0017d1e19a66ee07f0c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "55aece9c4b9253ec0318afd78a46d0136d4f6b6d1a018e394e69762d57f9256c"
    sha256 cellar: :any_skip_relocation, ventura:        "940ecfd6fb5a46b2d39f182cd10c8f738be2a3bff664c544dd4c7466178b035a"
    sha256 cellar: :any_skip_relocation, monterey:       "1de81641ae0c6205645751f4f9cbecfa788a7ce14f4dbff4f23675c6d8f5e8e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "e3917015f55056098ecb2f7526ca50df4ae90cfe6548ce3027708d2196009504"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38f294460a17ac1720cfe8c46b2958caf0fbf19c2cead23d468acf874d942f91"
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
