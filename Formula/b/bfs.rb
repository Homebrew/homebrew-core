class Bfs < Formula
  desc "Breadth-first version of find"
  homepage "https://tavianator.com/projects/bfs.html"
  url "https://github.com/tavianator/bfs/archive/refs/tags/4.0.2.tar.gz"
  sha256 "26ee5bf5a35cfbb589bf33df49ca05b8964e017b45faf16e520322c0e0ffad3b"
  license "0BSD"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d669af8d7e55974136ab5c720992b0d6b05e1673dab97148efcece18839dc88c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17236cce2be60931029d5ba9ff2394a0aefdb9a64fb9ca39d5ecbf70029e4562"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f734ac0b70cf848147e5e5cdb741ea1d0e9ab45555df9ee2586e82928d8d83e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "51a3b3a3ff6342652e58dcfbed78909db2649fa125c4c4bb3ecbfa55a4709344"
    sha256 cellar: :any_skip_relocation, ventura:       "acbc09521674531442125184ddaec20177dc4f4f3127aebb8dc10f37db8e113c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dac57e6473e18ea0097cf2592894f925923a08aae3ca5a1f46e3fbb9253943bb"
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
