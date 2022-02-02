class GitCinnabar < Formula
  desc "Git remote helper to interact with mercurial repositories"
  homepage "https://github.com/glandium/git-cinnabar"
  url "https://github.com/glandium/git-cinnabar/archive/0.5.8.tar.gz"
  sha256 "7971c2ae17d2b919f915efab35e3aba583b951d53ca2bc6ebf69bbd0c22f1067"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/glandium/git-cinnabar.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e82376d75a8481c1d14fc79a8c6ec7093260e05c7cb5007184914203ae91365c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "963c3f71356e10162265b3c2cd1abed252c84fe9424d350e4b96eabc360474d7"
    sha256 cellar: :any_skip_relocation, monterey:       "8436e3cc13ffbba4dacb0ae8f78689b841c428e6a9ea1c77c502c69ad5eeed9f"
    sha256 cellar: :any_skip_relocation, big_sur:        "290369e1d739f2d99209a8eed259efcff164af3ddf3c825b307450d59c2cfefb"
    sha256 cellar: :any_skip_relocation, catalina:       "1c0507389075c31707cf9024512d1c5cca9c996d07e4ce06a52859df9f039d9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "131494059a460bfe7f8364528af2ab6b9cb365638244f3ad2598f82f39e76fc4"
  end

  depends_on "mercurial"
  depends_on "python@3.10"

  uses_from_macos "curl"

  conflicts_with "git-remote-hg", because: "both install `git-remote-hg` binaries"

  def install
    system "make", "helper"
    prefix.install "cinnabar"
    bin.install "git-cinnabar", "git-cinnabar-helper", "git-remote-hg"
    bin.env_script_all_files(libexec, PYTHONPATH:          prefix,
                                      GIT_CINNABAR_PYTHON: Formula["python@3.10"].opt_bin/"python3")
  end

  test do
    system "git", "clone", "hg::https://www.mercurial-scm.org/repo/hello"
    assert_predicate testpath/"hello/hello.c", :exist?,
                     "hello.c not found in cloned repo"
  end
end
