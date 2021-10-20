class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  # NOTE: Please keep these values in sync with git.rb when updating.
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.33.1.tar.xz"
  sha256 "e054a6e6c2b088bd1bff5f61ed9ba5aa91c9a3cd509539a4b41c5ddf02201f2f"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "cd6882ac549c2c9d5dabee61cdac847c0ba7295c181d867df9bc4029c0e72add"
    sha256 cellar: :any,                 big_sur:       "902c7e3911cad311b00ae572c2af462224c0306ae6b46e8fd63f2dce53abfa2d"
    sha256 cellar: :any,                 catalina:      "7767a73b14eb155730144528416854bb8c209a2f61a2f7063a172c61efc43e4b"
    sha256 cellar: :any,                 mojave:        "fc450ca3f17b7ecae59ab16ebdf2450cd49a2f5fc39b210c7f3333e6948431da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c96b57ea04cdcc1b514bb62e8eab3631e637fe6fbbc4b67a90679e2431dc750"
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
