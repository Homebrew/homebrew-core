class Bfs < Formula
  desc "Breadth-first version of find"
  homepage "https://tavianator.com/projects/bfs.html"
  url "https://github.com/tavianator/bfs/archive/refs/tags/4.1.3.tar.gz"
  sha256 "64ed282aa3a1e05f10c9888943857cb1b0fb783e12ffd15500249383f13ea5b6"
  license "0BSD"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3681786e210c9628783089457a05377ac9dad803681973ace4cdd07943888900"
    sha256 cellar: :any, arm64_sequoia: "fa4c1a9d6b66b746a625e0d97c68f6c1f4fe3b2e0fe656593f251ca53e8dc8ab"
    sha256 cellar: :any, arm64_sonoma:  "eb90813fdebae1237f1945ffcb4c51c756f04766a4dc810a66b8878402d77c54"
    sha256 cellar: :any, sonoma:        "7cc68712104cbe092f2b31eee6869b17d89ce07dd6f260478df88140a25db2f2"
    sha256 cellar: :any, arm64_linux:   "4c6231df932d5c2bf677d321e0460688b1745a27a030d64d5723852bb86801dd"
    sha256 cellar: :any, x86_64_linux:  "e942bdc9092e86dc1cac3c22431a52e6df34786146e9c418793ee57fbaca3741"
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
