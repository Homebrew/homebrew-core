class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.46.0.tar.xz"
  sha256 "7f123462a28b7ca3ebe2607485f7168554c2b10dfc155c7ec46300666ac27f95"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a321d34691f89f26a9c2c729131b1f061426b88bc2f4ac8b9e94e58b088edcf4"
    sha256 cellar: :any,                 arm64_ventura:  "c2c17bdeae78beec03c49e0bfb601d9aaf6759321e23045718b2f0ed8e8b57f1"
    sha256 cellar: :any,                 arm64_monterey: "f3f6e9e824818b0b744941bc083f967aa365da990df014ded5d04c00419cc8be"
    sha256 cellar: :any,                 sonoma:         "db31200085e92dcb1e4b141113b1cc9a32da55901575441a14b71e674aeebf5c"
    sha256 cellar: :any,                 ventura:        "8246dd3d5f4acc88fed05dc0250870e85c3a3562e78fb02dba52fa20b1cd47ca"
    sha256 cellar: :any,                 monterey:       "053bf9a73237f599a1d324b6b24d1d6b9da9177ff2e6bdaad9f9e526dd7feb77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1a25aa7dea9acd6059daad73ad35a0c248cca40be19868e75ae6e30e8e141ef"
  end

  depends_on "pkg-config" => :build

  depends_on "glib"
  depends_on "libsecret"

  on_macos do
    depends_on "gettext"
  end

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
