class Ncdu < Formula
  desc "NCurses Disk Usage"
  homepage "https://dev.yorhel.nl/ncdu"
  url "https://dev.yorhel.nl/download/ncdu-2.1.1.tar.gz"
  sha256 "d6c2374ca50d40b6211346972a2e89c9601172fd0704d885eda5b1e09a2a48ed"
  license "MIT"
  head "https://g.blicky.net/ncdu.git", branch: "zig"

  livecheck do
    url :homepage
    regex(/href=.*?ncdu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fcc450b390fcf8c12105fa31c66962096058076a9342c47385a7720924fe123e"
    sha256 cellar: :any,                 arm64_big_sur:  "ef4257052ed5d0cfcd125d84cae0adcc9392c7911eb14f80b86a7e92b743b794"
    sha256 cellar: :any,                 monterey:       "269a12aff37eb757713ef1da816f769c9a5d89a93ae289af6563299e311ab9f2"
    sha256 cellar: :any,                 big_sur:        "2758cf2d073453d9b2ba00fca59af2d887b5f2759029504fedc3dcf02ba7d85f"
    sha256 cellar: :any,                 catalina:       "52fecaf89f0d6d491836617736d18f05e28db6a21f1b36c9955cf7888557c2d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5590f41a5f0b594ca7510f95d409cf53c9859bcbf4ab95938382d69282252d3c"
  end

  depends_on "pkg-config" => :build
  depends_on "zig" => :build
  # Without this, `ncdu` is unusable when `TERM=tmux-256color`.
  depends_on "ncurses"

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end

    args = %W[--prefix #{prefix} -Drelease-fast=true]
    args << "-Dcpu=#{cpu}" if build.bottle?

    # Avoid the Makefile for now so that we can pass `-Dcpu` to `zig build`.
    # https://code.blicky.net/yorhel/ncdu/issues/185
    system "zig", "build", *args
    man1.install "ncdu.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ncdu -v")
    system bin/"ncdu", "-o", "test"
    output = JSON.parse((testpath/"test").read)
    assert_equal "ncdu", output[2]["progname"]
    assert_equal version.to_s, output[2]["progver"]
    assert_equal Pathname.pwd.size, output[3][0]["asize"]
  end
end
