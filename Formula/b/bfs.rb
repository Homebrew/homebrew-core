class Bfs < Formula
  desc "Breadth-first version of find"
  homepage "https://tavianator.com/projects/bfs.html"
  url "https://github.com/tavianator/bfs/archive/refs/tags/4.0.5.tar.gz"
  sha256 "f7d9ebff00d9a010a5d6cc9b7bf1933095d7e5c0b11a8ec48c96c7ed8f993e5f"
  license "0BSD"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3456aab219ef3061d13327765f1463e48011ad18f8333567185900f7f618c0e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7535e67d7ca3c58c94529661d9c4af622c9698ecacbe1999918feff9420fd23"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3e1493b97bd3b87ad28c1e6c5ceb4f4d8a222be24b598d3d7a0af14bb23eae83"
    sha256 cellar: :any_skip_relocation, sonoma:        "95eb75798670394de7bd63eef90c109a726c61a64950e2a37c241f40344a9946"
    sha256 cellar: :any_skip_relocation, ventura:       "13300fb6040498c5a31bf3e51c05a898d5d20ac945ee7a6af175031fdef40ec1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dca1648d8339a7c4eb424655e73ef945c974fc6d62db80f3221ce0aaf7887faf"
  end

  depends_on "oniguruma"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1300
  end

  on_linux do
    depends_on "acl"
    depends_on "libcap"
    depends_on "liburing"
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1300

    system "./configure", "--enable-release"
    system "make"
    system "make", "install", "DEST_PREFIX=#{prefix}", "DEST_MANDIR=#{man}"
    bash_completion.install share/"bash-completion/completions/bfs"
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal "./test_file", shell_output("#{bin}/bfs -name 'test*' -depth 1").chomp
  end
end
