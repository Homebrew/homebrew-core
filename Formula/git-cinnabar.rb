class GitCinnabar < Formula
  desc "Git remote helper to interact with mercurial repositories"
  homepage "https://github.com/glandium/git-cinnabar"
  url "https://github.com/glandium/git-cinnabar/archive/0.5.11.tar.gz"
  sha256 "20f94f6a9b05fff2684e8c5619a1a5703e7d472fd2d0e87b020b20b4190a6338"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/glandium/git-cinnabar.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "715bfee957b00c42ab1d691cd2a1525ddd70db2112cde19ebd9310ed83ec2035"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb9cf222a1ece6ea3852224328a6cf7243fc606ceefb8150d2c557d45ca2c51d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12acb5d61f08fa07b79883444fff480236385cbefa5aa6edf322bb2c3f0543bc"
    sha256 cellar: :any_skip_relocation, monterey:       "7d4e71a53d9a5ecb803097786f574bcd55207f44887c74c829edd3a595b59fa4"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0c8ca6663fbf43e90a904ad3ca41f7174f78f023938029efde89ef312dceed6"
    sha256 cellar: :any_skip_relocation, catalina:       "b6e9691219d9e23b3107e9fe78f1cd7e454212ba0999ce2236f222322367784d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e85cbe77244c8ece4095ca96cb76fcb8a54d322f20226c97339b298478feb3b4"
  end

  depends_on "mercurial"
  depends_on "python@3.11"

  uses_from_macos "curl"

  conflicts_with "git-remote-hg", because: "both install `git-remote-hg` binaries"

  def install
    system "make", "helper"
    prefix.install "cinnabar"
    bin.install "git-cinnabar", "git-cinnabar-helper", "git-remote-hg"
    bin.env_script_all_files(libexec, PYTHONPATH:          prefix,
                                      GIT_CINNABAR_PYTHON: which("python3.11"))
  end

  test do
    system "git", "clone", "hg::https://www.mercurial-scm.org/repo/hello"
    assert_predicate testpath/"hello/hello.c", :exist?,
                     "hello.c not found in cloned repo"
  end
end
