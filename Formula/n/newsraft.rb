class Newsraft < Formula
  desc "Terminal feed reader"
  homepage "https://codeberg.org/newsraft/newsraft"
  url "https://codeberg.org/newsraft/newsraft/archive/newsraft-0.30.tar.gz"
  sha256 "5ae782d7eb19042cd05e260c8ec0fe4d0544e51716885a4b1e96a673576bd998"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "29fd1bfb589d23856ba5a4c8a7833f8a017bfb942dcef041d73d0dbede4da802"
    sha256 cellar: :any,                 arm64_sonoma:  "721539470524ce3d472ec99f9ed3791d5f82ce34136c4c85850b672fc74221d2"
    sha256 cellar: :any,                 arm64_ventura: "feb7572e11c73b7a8b86d59b0e1147eac7767f2f1c59496777ff4889d9a94b2d"
    sha256 cellar: :any,                 sonoma:        "b566119c0a0fb37b2f5b2a925a61e787acb00202c227ef415a4ff67e7805aa9f"
    sha256 cellar: :any,                 ventura:       "588e84062f56bbf2815eb8c094f679d33fd7b8c20f7cc7435391e12aa88a4fbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b555f5fa493b75a38832a89bb6e395892d6de46b7dea689dea1872a4e1a773fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c15e9536c644f1251c32c5ee67b74582425545f1d48987dd51c0918485760e4d"
  end

  depends_on "scdoc" => :build
  depends_on "gumbo-parser"
  depends_on "ncurses"
  depends_on "yajl"

  uses_from_macos "curl"
  uses_from_macos "expat"
  uses_from_macos "sqlite"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/newsraft -v 2>&1")

    system "#{bin}/newsraft -l test 2>&1 || :"
    assert_match "Trying to initialize curses library...", File.read("test")
  end
end
