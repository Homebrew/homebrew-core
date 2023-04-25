class GitCinnabar < Formula
  desc "Git remote helper to interact with mercurial repositories"
  homepage "https://github.com/glandium/git-cinnabar"
  url "https://github.com/glandium/git-cinnabar.git",
      tag:      "0.6.1",
      revision: "90581ff3c854e4ed8b9c8fa35e8216238992abad"
  license "GPL-2.0-only"
  head "https://github.com/glandium/git-cinnabar.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e38e5a24b9f8b45b463265a7c50e4d464ce6a06fa58d0ff77388cc605d63dc58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e80085be6cd38aba562d66d069cf0104f9ab24b11dd5a385256106572a581f36"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7ec7bbdba120dfdd440d372c70b9117217c0fb371b375f621c2e84f08315e9e"
    sha256 cellar: :any_skip_relocation, ventura:        "3111cc0e1bd2cb774127de2371b9768ca95eda473d737cbe7526a61d03bf82c4"
    sha256 cellar: :any_skip_relocation, monterey:       "d49e0b8e0e73db7d116e719da613b611564291c048bd230d6efbe8efd4c3324d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c953d52df24eb49badb9572a2e96227ecc7c030cab247f0a29cd22613b58cb0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53904f661d4fc52218d8aa16a7e96c90d4dd4cff22d8a8a0bfd995e89bbe9490"
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
