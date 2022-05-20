class Mp4v2 < Formula
  desc "Read, create, and modify MP4 files"
  homepage "https://mp4v2.org"
  url "https://github.com/enzo1982/mp4v2/releases/download/v2.1.1/mp4v2-2.1.1.tar.bz2"
  sha256 "29420c62e56a2e527fd8979d59d05ed6d83ebe27e0e2c782c1ec19a3a402eaee"
  license "MPL-1.1"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8df3b3e7bd1fc6800cb3763528b1d8bc7b073151be7feaafd80f6ee27f516c4b"
    sha256 cellar: :any,                 arm64_big_sur:  "42bbed27ea0af8368259c8b4a601ff0d4708445e9abf3e6e7d1b267a9951229b"
    sha256 cellar: :any,                 monterey:       "4d352b9521211a6c20d3f4bbcc15dfa7c7438e46e09325b3af889a58b62107e2"
    sha256 cellar: :any,                 big_sur:        "15a021638c2230c8cf08b35cb4ec3fa7b6f3a2ba3cbf0350edace7e6fb8d39e8"
    sha256 cellar: :any,                 catalina:       "d69a185550432da8ffa321afdf176abe98d2a30710e9d1a7154caac707e68033"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3d4b79d24929179bfb200ddbb0af619c863d5342cde5a3ee113e97fee488437"
  end

  conflicts_with "bento4",
    because: "both install `mp4extract` and `mp4info` binaries"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
    system "make", "install-man"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mp4art --version")
  end
end
