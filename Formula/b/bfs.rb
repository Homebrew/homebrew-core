class Bfs < Formula
  desc "Breadth-first version of find"
  homepage "https://tavianator.com/projects/bfs.html"
  url "https://github.com/tavianator/bfs/archive/refs/tags/3.2.tar.gz"
  sha256 "86b17cab7b213f36e93639eceba3ffa86e1556d12a1db8955c8c7e53b2e94140"
  license "0BSD"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d2f56d120c55ba35033a677f7393ed2290c2e7a88dd68bda94b937bf5efa4731"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "212d2a66124c4df5b1f925247a43f44f3a378f1a50cf47cf99c4c01dbca9353b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a9d266bd7012284fda1278042ce001d153c0491e29f1f14ba96f6a2b4fc0502"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba54e91c9862916cb262c708a4e07f2bab7eb39a4d24e64983fecb1cd4cd1a55"
    sha256 cellar: :any_skip_relocation, ventura:        "cde9065b0bdad7cd486a0a7137070703a8ee8df84775c2aa8fc5c5ddc71aa130"
    sha256 cellar: :any_skip_relocation, monterey:       "c91ec4f9d75db95b62edf55d43cba954c004cbfbcb8d2999a28a5049a893156a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da6b11e3fd7203b900b0871b1a6d30898ff3935d1ce06e213d9aa13eeeeb49f1"
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
