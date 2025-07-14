class Bfs < Formula
  desc "Breadth-first version of find"
  homepage "https://tavianator.com/projects/bfs.html"
  url "https://github.com/tavianator/bfs/archive/refs/tags/4.0.8.tar.gz"
  sha256 "0b7bc99fca38baf2ce212b0f6b03f05cd614ea0504bc6360e901d6f718180036"
  license "0BSD"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2220d279772e57a1628bc6b7f06f9b2b59355f41bbe6673ab6a9b749e0c58cf0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d39198406126856fc36850d9eccf7d70d73a36d68c38a27af5372af39e7b8ccd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "354600bf744a829dd7d76e2647103ba7e1ed3b95a80a530559c1ddceb123b8aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7db79a8f1670bc856933d3a8d968339ce69f240c07d1fcfbabede47fae31582"
    sha256 cellar: :any_skip_relocation, ventura:       "6a4a94b5363a21a671b924afe74422b4a73a7d93fc7c82280b913b79d7fffb6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "608853d79a4ddd1b048c43e985c59fac82fa919b6b975b023c09d797c63facaf"
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
