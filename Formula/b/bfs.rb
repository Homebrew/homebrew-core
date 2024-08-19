class Bfs < Formula
  desc "Breadth-first version of find"
  homepage "https://tavianator.com/projects/bfs.html"
  url "https://github.com/tavianator/bfs/archive/refs/tags/4.0.tar.gz"
  sha256 "3c13462a39e8e7ccfe8e9bc06562c52e14fee000e1fb4972c3f56996de624c02"
  license "0BSD"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "06f36d10a51f402b43506e6396e7063fad1bde6bfa2775a9b306c5b94ab9c325"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "45b882ca4f70b490033e2babb163e1d6db2779efc896ad84e15d7c08b247d9b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c21210d49ab5590e3be98e696258ee202327cc016b4156f92b7b44063b8f2faa"
    sha256 cellar: :any_skip_relocation, sonoma:         "0e8becaa6af9ea3780c50478f9d79522872efe89133cc647e27f2856a41d3834"
    sha256 cellar: :any_skip_relocation, ventura:        "a09848421812a9235519085cf1e01ba51d9efc70be52b670038d9f8846ae7aee"
    sha256 cellar: :any_skip_relocation, monterey:       "1cf151bab4770f5df37112950d4770f71971e7009166a33a1b7e87088652e96a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdaa86d14d68a9d3037099915b0d11fa51780b27ffc14953ee1721d850b150d0"
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
