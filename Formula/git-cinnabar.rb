class GitCinnabar < Formula
  desc "Git remote helper to interact with mercurial repositories"
  homepage "https://github.com/glandium/git-cinnabar"
  url "https://github.com/glandium/git-cinnabar.git",
      tag:      "0.6.0",
      revision: "c224e301ad05f4e337b0833a57fde97d41154d7d"
  license "GPL-2.0-only"
  head "https://github.com/glandium/git-cinnabar.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6aa3fb806dbf78026d50e74c16e8db7d45dcf0035a1205f6c8c0b16ce392ac44"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66d253c35ea1ccdc569264ec5edd562e80e7d22c3ade6406fac3009c91cb5a27"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "91c082acc967c3a0f93e3a7ee1e6613f3409068955357a1e3a0332462e71fb61"
    sha256 cellar: :any_skip_relocation, ventura:        "63ac26030f9bfc3e6b23640b918f3e54d634c8cc7ece57ba7bba4814e83ff39d"
    sha256 cellar: :any_skip_relocation, monterey:       "6b7bc3946a5c23d77849ab50b7c477444309f82962b6d3382c77cf8692658cf3"
    sha256 cellar: :any_skip_relocation, big_sur:        "aebf0ef6424001482b13d7f91f0a18a66cadcf815a8aa0e4b2cb8592bb180677"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c23b6ff99c0de26c8a9ab1d415fbbf1e48170ac3325a4a8d93579c695e4988c"
  end

  depends_on "rust" => :build
  depends_on "git"
  depends_on "mercurial"

  uses_from_macos "curl"

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
