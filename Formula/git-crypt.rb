class GitCrypt < Formula
  desc "Enable transparent encryption/decryption of files in a git repo"
  homepage "https://www.agwa.name/projects/git-crypt/"
  url "https://www.agwa.name/projects/git-crypt/downloads/git-crypt-0.7.0.tar.gz"
  sha256 "50f100816a636a682404703b6c23a459e4d30248b2886a5cf571b0d52527c7d8"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?git-crypt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d86478df1906cc9337c7ea815005c1bbd7e970462476cb03fa645afb06c5eb68"
    sha256 cellar: :any,                 arm64_big_sur:  "7adc43408c0cbea8bf9d5f01a70e5559d3282062d40cc99a6bfdd831aacea10c"
    sha256 cellar: :any,                 monterey:       "2f3fe932411fdcf3e156bef702067812d395b65d95319e62b6e9308d7cf487fc"
    sha256 cellar: :any,                 big_sur:        "c6080d2eaa5f60f0a7236137d6bc7ae18f707ad2c95f7a5f28d601732eda8fa2"
    sha256 cellar: :any,                 catalina:       "a12782583f1f22cd862db9b4b6507044066623fff29d59123b4ddc35fb2bcd21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62d497660a8206870bb049f002cdac71550c654da92ca447e3ade56895bbd039"
  end

  depends_on "openssl@1.1"

  def install
    system "make"
    bin.install "git-crypt"
  end

  test do
    system "#{bin}/git-crypt", "keygen", "keyfile"
  end
end
