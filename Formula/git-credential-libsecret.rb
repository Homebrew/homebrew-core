class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.39.1.tar.xz"
  sha256 "40a38a0847b30c371b35873b3afcf123885dd41ea3ecbbf510efa97f3ce5c161"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f8fbaaa99240d43a80a2a373ef0364affdd990985467c71742e4b76e2fe7a019"
    sha256 cellar: :any,                 arm64_monterey: "5c9458442ab8dc646ee1fb5102c41963eda92c289737c70b3a280c3c7f533ca7"
    sha256 cellar: :any,                 arm64_big_sur:  "7e3fc836aa5e3af9879dfd17a93399d43928dfe541a9212beaf6944393d25a5b"
    sha256 cellar: :any,                 ventura:        "687336f0c090edfa9dede20c5e5aec93eaeead3d3a69f5311b39ee20d3e6ce15"
    sha256 cellar: :any,                 monterey:       "4e126ea4ebfb611e8b4a3663ce1b2212485a9fcb71fef3e4abc7179d748217a0"
    sha256 cellar: :any,                 big_sur:        "415bd1bf71dd6719c4d69e57202229adbea40107399d9acf95dc0c605c91480a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c32ceb65615e586237563fbd7952a5d0b893c47b33ba035d23d165de0bd9f7b0"
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
