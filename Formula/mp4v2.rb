class Mp4v2 < Formula
  desc "Read, create, and modify MP4 files"
  homepage "https://mp4v2.org"
  url "https://github.com/enzo1982/mp4v2/releases/download/v2.1.2/mp4v2-2.1.2.tar.bz2"
  sha256 "0b943133673cffd4625247783e34080797de7386142061a6613e0c26285953ef"
  license "MPL-1.1"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f282c0ff88150b4957700442ef8edeb841460771a32b34aa248f4a68fdd73b08"
    sha256 cellar: :any,                 arm64_monterey: "a5afb539310516fa2d8ad5363d0874e8b34134459f3b1468464a78dae4fc50d6"
    sha256 cellar: :any,                 arm64_big_sur:  "6912df38e972c5e015f0e22b8e820b01242f0d17fc16d24727f1bfd86613fb5b"
    sha256 cellar: :any,                 ventura:        "f42442bbfa89f14ad5b213c6b6b264547eb8c6794299d1b94f28307e9df67799"
    sha256 cellar: :any,                 monterey:       "e6d12e43861a2e04281bcbb975ccfdb15ca55df3b83e6f3166872c104da078e2"
    sha256 cellar: :any,                 big_sur:        "e7df1993f4be61c91f42439bda77dd9845d66e5b32a399f02576737c12295ef2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "961bdcc5e88c1ec8670460b70cbf12bf484a3a068054729900286abca099e48d"
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
