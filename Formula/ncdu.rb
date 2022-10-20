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
    sha256 cellar: :any,                 arm64_monterey: "8fba33d5bca5d0b4fdadd28cc9a287de19a46d5df77a7c1535bc285a048fd094"
    sha256 cellar: :any,                 arm64_big_sur:  "6120a796bc6b311b8b8415ab9d6fa6d6434bdbaffe559b83e58ad7545e67227c"
    sha256 cellar: :any,                 monterey:       "40cde85940209ac41b64646ec5462791cfdcea1d2419e95a835b0de0554cdbdc"
    sha256 cellar: :any,                 big_sur:        "53810b01d02b7d09c200d9f221fcb5a52accd9d40180c4ca3cc74ea5abea9b14"
    sha256 cellar: :any,                 catalina:       "3575ae3f1050a7cf12f1a6b64ee1a28cd366971eec9f8854f2a39cf876402568"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01148e8937e60ed15cc2c928e986fa3e74541e15c677083f51ad6f208ca9b53f"
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
