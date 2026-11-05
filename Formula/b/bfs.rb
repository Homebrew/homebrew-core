class Bfs < Formula
  desc "Breadth-first version of find"
  homepage "https://tavianator.com/projects/bfs.html"
  url "https://github.com/tavianator/bfs/archive/refs/tags/4.1.6.tar.gz"
  sha256 "5b706e1b362c1f05093e1436b396fc8129c6e456a112b9e4a06fd7916f19baaf"
  license "0BSD"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "83e4c96d705d6f79dc3927eabaceaf4255d8a8de5036633b0a1bf7eaeb2f4e41"
    sha256 cellar: :any, arm64_tahoe:       "ee5a76e170183bf201058b74e1d315d8ccdde4feb5c1d680250c2267c2681c52"
    sha256 cellar: :any, arm64_sequoia:     "e61022fd6866cee8e1057c76971f5531327f799786c4f6168e111bd3851937f8"
    sha256 cellar: :any, arm64_linux:       "6484b727170d1eb281464db71e62daee227e75f987c4549d86413c2c90c83b31"
    sha256 cellar: :any, x86_64_linux:      "28261238752522d2048f830e3bf4f62b6f5a37454a39e356f9fe5fc0d36ac367"
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

  deny_network_access!

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
