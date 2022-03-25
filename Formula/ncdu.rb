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
    sha256 cellar: :any,                 arm64_monterey: "e09cf45115e102f9992dd5c1d839f87369783bfb59cdf6f295a0592763dd11cc"
    sha256 cellar: :any,                 arm64_big_sur:  "be6f5ce58e1703c885f5639149c78251be6f0303cf75fb6f982b55090e5dc767"
    sha256 cellar: :any,                 monterey:       "d850666244dea2662d918765670b292eae2e17b0eeff178f7c6d077b114bb7d2"
    sha256 cellar: :any,                 big_sur:        "2c05f0f0f7de8b1f6ff514b5eae5e238dafd51223200b767c89f124aa7431fd1"
    sha256 cellar: :any,                 catalina:       "7492e79156d7df55cbb3247ceb188e3c5ff4d780726f22352dc3af1fc0c32e4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "275b0d6c7bcc52ae4851cafffbe8e6f553eeaf651629937f12df67c592fe4d1f"
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
