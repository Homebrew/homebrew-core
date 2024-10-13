class GitCinnabar < Formula
  desc "Git remote helper to interact with mercurial repositories"
  homepage "https://github.com/glandium/git-cinnabar"
  url "https://github.com/glandium/git-cinnabar.git",
      tag:      "0.6.3",
      revision: "830a1f2c75fa91cf509020d16d19698a159cf22e"
  license "GPL-2.0-only"
  head "https://github.com/glandium/git-cinnabar.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "99c02a643befda05778ed9b365be8e082140800e74faf1413e3ba58f23f0c97e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ec8094c3444e434cb9e580e557b91cd3485038298042fd4aebbfeabff8ba7f5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ddf4e52af50bac133c8877f0e6a1d43a212109486a3fcafbe366ddf6e626db6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25b5ee9e84d9727139db12076fa763c60f18672a411ce381abbd1d92e49591f7"
    sha256 cellar: :any_skip_relocation, sonoma:         "c30765fd16526a147917232d187b8e29942da4f94424a7cdc18590d3603a4318"
    sha256 cellar: :any_skip_relocation, ventura:        "138a2b8ef8e48750cf057f3b8e10c3a4fe3636e019fa5db296f66ed096e8fcfa"
    sha256 cellar: :any_skip_relocation, monterey:       "3bea846899473f3954266b82561067e0d91d0ba93ec28cdf6fcf8677be9b47cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c449068a55d96e667dcbc19f84df226ce39aac3a41b8f5c3be68101667e29c3c"
  end

  depends_on "rust" => :build
  depends_on "git"
  depends_on "mercurial"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  conflicts_with "git-remote-hg", because: "both install `git-remote-hg` binaries"

  def install
    system "cargo", "install", *std_cargo_args
    bin.install_symlink bin/"git-cinnabar" => "git-remote-hg"
  end

  test do
    # Protocol \"https\" not supported or disabled in libcurl"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "git", "clone", "hg::https://www.mercurial-scm.org/repo/hello"
    assert_predicate testpath/"hello/hello.c", :exist?,
                     "hello.c not found in cloned repo"
  end
end
