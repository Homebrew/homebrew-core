class Ncdu < Formula
  desc "NCurses Disk Usage"
  homepage "https://dev.yorhel.nl/ncdu"
  url "https://dev.yorhel.nl/download/ncdu-2.1.tar.gz"
  sha256 "4ba8d20a64a55cc00af2d2c6138afcc9dc25e40a5ed6a8c544cb9e2285a195fe"
  license "MIT"
  head "https://g.blicky.net/ncdu.git", branch: "zig"

  livecheck do
    url :homepage
    regex(/href=.*?ncdu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "66387cf63e895e19e4699a2f7ca8faac78bc2d95908b04bf25871d366d1f7d98"
    sha256 cellar: :any,                 arm64_big_sur:  "2dcc4f6ed4b2b7f6936a0b483dc116a33d61206a09bdb4cd48bfbca1c7567489"
    sha256 cellar: :any,                 monterey:       "d3aa0fa0b9088b99ac88d66fcc942820593410ed52b170459757290251611d61"
    sha256 cellar: :any,                 big_sur:        "d412637b5a1c8fb8d5cfae2ea5268ed5996091e06149be17ebfe27fca31a415a"
    sha256 cellar: :any,                 catalina:       "ad381a76d1b6f31fa7a8c0cfc43c922e3fa97d9d8a29f495caa52e3e0821a892"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd840f97c9e3571b3fa59528634ee8a35aa11a0a79f951c9df052817ed171098"
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
