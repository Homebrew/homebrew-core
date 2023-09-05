class Dns2tcp < Formula
  desc "TCP over DNS tunnel"
  homepage "https://packages.debian.org/sid/dns2tcp"
  url "https://deb.debian.org/debian/pool/main/d/dns2tcp/dns2tcp_0.5.2.orig.tar.gz"
  sha256 "ea9ef59002b86519a43fca320982ae971e2df54cdc54cdb35562c751704278d9"
  license "GPL-2.0"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/d/dns2tcp/"
    regex(/href=.*?dns2tcp[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6476349ed65c44a7cbeddff8ce0322f80ed347b7382a5108dc4128be0871161"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bcfed251acce767235024339591706ee761691a01b447acfb289f447a662cc8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7342bad79a49f0cd2049fe73e9545ae691d83087e285d97b926bd3e29b7f0643"
    sha256 cellar: :any_skip_relocation, ventura:        "d922e172d654f0bf200d345d526ad150c57bf77376b8a022a76b98e594494100"
    sha256 cellar: :any_skip_relocation, monterey:       "02373e78d9c7f416d795a640058537f1edafb82a59b5406b019ed80b4b57c3f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "09b03661d759932c928ae63c72af41a528f6378d6f23e67e0341592ecba34a47"
    sha256 cellar: :any_skip_relocation, catalina:       "f1517166d8e8e02dbefbb654214012a6bf089ab78a1a237c9ec7d86c356da97f"
    sha256 cellar: :any_skip_relocation, mojave:         "f44f4f2e761da51c4552b6c394ae3ee48e2c1ff8b1b506cf35e648b3331b49dd"
    sha256 cellar: :any_skip_relocation, high_sierra:    "d6fb240175854e0a0b5069544a58c4fbcd161d3337288c2f289f48999c4dde10"
    sha256 cellar: :any_skip_relocation, sierra:         "e948ddde1e95f055a9cd3e73cd2756c22f729d9feed9ebc2929cb3df6fe09584"
    sha256 cellar: :any_skip_relocation, el_capitan:     "2cd5e77bec42f0f5e2715494c38eb8773ab30d53b140509d3f428d38890bf640"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44282da4806ffc130f6a3326925e708d70379c9c44ec735b251010927d5b920e"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    assert_match(/^dns2tcp v#{version} /,
                 shell_output("#{bin}/dns2tcpc -help 2>&1", 255))
  end
end
