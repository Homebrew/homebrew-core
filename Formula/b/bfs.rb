class Bfs < Formula
  desc "Breadth-first version of find"
  homepage "https://tavianator.com/projects/bfs.html"
  url "https://github.com/tavianator/bfs/archive/refs/tags/3.3.1.tar.gz"
  sha256 "8fb3df6687cd0a50411c5b381317d10590787e262d44fc5f0d294a64f0ab397d"
  license "0BSD"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "57aabe684fd262618a3c8d665ab3abdfdff3d347a79c7e5d454792302661f0e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d6d61d305bd635156c4cad3972f9d2ab1035ec70926d1dfa4e62a55e52a2b93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98642dba4e95975b616b09dcda2c6fe4ba4b25952d833cdddeb68472499af0ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5607770d006f1b3d80b7af032099d6db5e9006873b0a21957d189ec9404d059"
    sha256 cellar: :any_skip_relocation, ventura:        "c797c225e7571099609d519d4ba69cd4e7988f7d267c38dadcb57218fb975578"
    sha256 cellar: :any_skip_relocation, monterey:       "4cbb4c5f89f1db212128be1b93fe80a35c7f6a8c29792bf4eaf0114db7259325"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2997a9ea22be9fcabfdd0dd9ae1f0b5454742b43e6956b40fe86904e4cc1c072"
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
