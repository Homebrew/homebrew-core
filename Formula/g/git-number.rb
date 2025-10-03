class GitNumber < Formula
  desc "Use numbers for dealing with files in git"
  homepage "https://github.com/holygeek/git-number"
  url "https://github.com/holygeek/git-number/archive/refs/tags/1.0.1.tar.gz"
  sha256 "1b9e691bd2c16321a8b83b65f2393af1707ece77e05dab73b14b04f51e9f9a56"
  license "ISC"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "f006192cf61d5d3c178201835e847dff5c2c351578d90f183f7ef7363d1a1255"
  end

  # Fix for main branch name in tests
  patch do
    url "https://github.com/holygeek/git-number/commit/3da16b37716455ef1dcc9f617a89e003581b5188.patch?full_index=1"
    sha256 "6e7ed0dfcd86b1e8ee4ada9688aa12be9e33c4d9bb6928cf59dda653aa3c716e"
  end

  # Necessary for next patch
  patch do
    url "https://github.com/holygeek/git-number/commit/743d06416f097da4f39f4be7883aa755c8a2edfb.patch?full_index=1"
    sha256 "88544a6312df728e83dd7c421be57427a155742e51363903c48a707b8e29ade7"
  end

  # Fixes fatal: transport 'file' not allowed, remove with next release
  patch do
    url "https://github.com/holygeek/git-number/commit/e699e92394fa6a4ecbc4d7235925e9080a61aaa2.patch?full_index=1"
    sha256 "92d77a6c06fd579e79ab95c9c2d1d461d0f4e0a7fc28217dbb24aeae60d0bec9"
  end

  def install
    system "make", "test"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    system bin/"git-number", "-v"
  end
end
