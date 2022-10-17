class Ncdu < Formula
  desc "NCurses Disk Usage"
  homepage "https://dev.yorhel.nl/ncdu"
  url "https://dev.yorhel.nl/download/ncdu-2.2.tar.gz"
  sha256 "79289f2f1af181443b338598269555175b756665b72aacc6a810f9352e0204de"
  license "MIT"
  head "https://g.blicky.net/ncdu.git", branch: "zig"

  livecheck do
    url :homepage
    regex(/href=.*?ncdu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5b2f014ed878a5402ab588810bfab00ad3c53bea56fb540f638c757d69ff37fb"
    sha256 cellar: :any,                 arm64_big_sur:  "c5cd8b46859d78923d564b30a797cc0e631591c41df84f54cd1897b13d9543be"
    sha256 cellar: :any,                 monterey:       "04f5c6961fe800ceac83d793a4781adcbcb87a58be6c0836798f73462bfac5d2"
    sha256 cellar: :any,                 big_sur:        "fc687682b0a3a6c8524adc6b0c8803079121f7ce2ca40b257e7e56131ec03515"
    sha256 cellar: :any,                 catalina:       "a1a6be988dbeb8b211bd29964b85fca0d66c0935e05402519e3793c75521a3c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c165a42d391ca8ad87f1a9d8f4234841cbe1aa51db7f65dc873c1c0cf4a30d59"
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
