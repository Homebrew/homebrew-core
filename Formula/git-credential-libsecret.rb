class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.38.1.tar.xz"
  sha256 "97ddf8ea58a2b9e0fbc2508e245028ca75911bd38d1551616b148c1aa5740ad9"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "579f98bcd04f2b1e895df0ae0feac549ac969e8b9b85ff64fdaa11de1ced9be6"
    sha256 cellar: :any,                 arm64_big_sur:  "0c300b7c78d1f30535a68dc603431c0069a734da942160f71dfff29f1d9b3fac"
    sha256 cellar: :any,                 monterey:       "42070e7972cee22a49fcec3f9dd888bdcd30b5d7565ad76ebae1ef6ec7d01593"
    sha256 cellar: :any,                 big_sur:        "393c917a053abaaa57972b15335e5c082b68b7058140473963d44664f5556309"
    sha256 cellar: :any,                 catalina:       "806818b71b6513a272830b143a6c0c882c30d46779e9d4b9e69c33eb7f648b2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cea1f7669378868ce18d356e558fb755afe002c8cdc7de2cd79c377986444762"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libsecret"

  def install
    cd "contrib/credential/libsecret" do
      system "make"
      bin.install "git-credential-libsecret"
    end
  end

  test do
    input = <<~EOS
      protocol=https
      username=Homebrew
      password=123
    EOS
    output = <<~EOS
      username=Homebrew
      password=123
    EOS
    assert_equal output, pipe_output("#{bin}/git-credential-libsecret get", input, 1)
  end
end
