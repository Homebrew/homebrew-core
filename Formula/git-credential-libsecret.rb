class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.40.0.tar.xz"
  sha256 "b17a598fbf58729ef13b577465eb93b2d484df1201518b708b5044ff623bf46d"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "24a4ab12987359ef3d185030fc6abf5af5dea34ac51857a42ed773cdda67a9a9"
    sha256 cellar: :any,                 arm64_monterey: "3e37230178aa71e17262bd358bfee48d076743cdebc7fa2c820898e1f75c646f"
    sha256 cellar: :any,                 arm64_big_sur:  "24be2d5ba788182e96052c8f36301d479e04540c132aece201cf73ee8f49a629"
    sha256 cellar: :any,                 ventura:        "2c79106e33f7f0b9c32bab625a8fa068493775040858f141ac09494416321bb0"
    sha256 cellar: :any,                 monterey:       "faee44fcfca0318b5dfe85e835787517083d2aad13fb485558121e3c3be97289"
    sha256 cellar: :any,                 big_sur:        "a41926ec3649d23baf38ea809441e371aef0d6b37265cfc793665b1574eb4403"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4680e707cba0f63216c278861dc5214099b53214a13b7944a907067d1422e65"
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
