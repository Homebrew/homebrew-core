class Bfs < Formula
  desc "Breadth-first version of find"
  homepage "https://tavianator.com/projects/bfs.html"
  url "https://github.com/tavianator/bfs/archive/refs/tags/4.0.6.tar.gz"
  sha256 "446a0a1a5bcbf8d026aab2b0f70f3d99c08e5fe18d3c564a8b7d9acde0792112"
  license "0BSD"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "541eb3e80f111ffbe3cce64f99d86cd806e94fd94635052dd92fcbe34b7c4b7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56bf0b3dff7830ad54fed7cc0dffa27f285f5b4f541c9abe17c202308ed55288"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "363fe54480b06f1295595614ce3132867baaa27e6b9f956590d0dd6a86c562e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "91b95a911f42b6b95745b4ac48b9c9a687164eb9955b955bd85118bf7210ee41"
    sha256 cellar: :any_skip_relocation, ventura:       "6331cec89c8342f88c7230eddb2ea3d0d79b27a3d10acad159b2794905268dab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95da5b6d24d640a1285bfdd20ad22aa9c5f3ba3de94e27bd95c0cecd09bf247d"
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
