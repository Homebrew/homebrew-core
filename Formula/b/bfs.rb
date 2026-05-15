class Bfs < Formula
  desc "Breadth-first version of find"
  homepage "https://tavianator.com/projects/bfs.html"
  url "https://github.com/tavianator/bfs/archive/refs/tags/4.1.2.tar.gz"
  sha256 "4dc9846bbd23acdad4bafb279416b4a60aee98829ab6c5a1380006ab28894f3d"
  license "0BSD"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "839d14f789c91847253222703780ff73141bbe93e9ce189d9527778ea69776df"
    sha256 cellar: :any,                 arm64_sequoia: "ce110d36d7e33828fac81c7edeb015779551861d78734acd0846857f667093aa"
    sha256 cellar: :any,                 arm64_sonoma:  "fcd52ecfb0eb7ea55d4e76614e9a480bd5b4523659a18c3476065aabedfc32ee"
    sha256 cellar: :any,                 sonoma:        "3505bd11e30ca79704741b212628838bff2f506c729cc843820e2592a3fbb823"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9eb1c0f5f78f3b7bddd0018eb175b19a9e7fb474d36713139df6884cfebdf1b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fda93bd8ea0f52822e713e70791e916317143cabc34ef723ebca8e74d748cb0"
  end

  depends_on "pkgconf" => :build
  depends_on "oniguruma"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1300
  end

  on_linux do
    depends_on "acl"
    depends_on "libcap"
    depends_on "liburing"
  end

  fails_with :clang do
    build 1300
  end

  def install
    system "./configure", "--enable-release"
    system "make"
    system "make", "install", "DEST_PREFIX=#{prefix}", "DEST_MANDIR=#{man}"
    bash_completion.install share/"bash-completion/completions/bfs"
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal "./test_file", shell_output("#{bin}/bfs -name 'test*' -regextype emacs -depth 1").chomp
  end
end
