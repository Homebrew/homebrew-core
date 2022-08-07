class GitCinnabar < Formula
  desc "Git remote helper to interact with mercurial repositories"
  homepage "https://github.com/glandium/git-cinnabar"
  url "https://github.com/glandium/git-cinnabar/archive/0.5.10.tar.gz"
  sha256 "20792358201417fa64cb3b1b9ccd6753909f081b0bf11cb9908f55a3607627e1"
  license "GPL-2.0-only"
  head "https://github.com/glandium/git-cinnabar.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39a553207e19f87aa96eb80fc114eaac9ce0a39cf21d4d2c2e209ebd274976be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3793651e14c75b50aff02841ab439b8c7e1fc402df6037de4ae94e928f5be506"
    sha256 cellar: :any_skip_relocation, monterey:       "25bf1f373096f1ba8180a27228107587bc1ec19d7b796a6539e19f820803a621"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ee691bb51538985c7f2631595eabf6fc52519591b2c534a428b3c446ea20f4d"
    sha256 cellar: :any_skip_relocation, catalina:       "c24fffab857c576ce3caeccddc5d7c11d5d9b8c21f1c4b69400fb583d56c6ca1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92f070b07c52b1ee0f4b76946511faa4ae0a4b62eb0f74a3994a52a7552cd5c3"
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
