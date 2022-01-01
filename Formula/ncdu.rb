class Ncdu < Formula
  desc "NCurses Disk Usage"
  homepage "https://dev.yorhel.nl/ncdu"
  url "https://dev.yorhel.nl/download/ncdu-2.0.1.tar.gz"
  sha256 "2f79d50c3eb8301c8bde8b86e1071c31ea9387373077302ffbf387df63477c48"
  license "MIT"
  head "https://g.blicky.net/ncdu.git", branch: "zig"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19c91668519f2b1784ae4311e46748367d0375116e15fcfd181cae5958141a4c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "13547d13f18fbbb6dffe62b7d81153203795beb9cf3847c0c38cbcdf4febd5fd"
    sha256 cellar: :any_skip_relocation, monterey:       "760f5aac6aa0605b86d05c9a9f5095fc338c1c9addf0fc212235e9842afbbee9"
    sha256 cellar: :any_skip_relocation, big_sur:        "f50bc74c04bc4a52595da6aebaedbfc7a4e0c97fda59d9db2f425c44ee8f83df"
    sha256 cellar: :any_skip_relocation, catalina:       "54f3bda26959ef758817a57c42b892c96627e7d80b5b9c817070b2ed70bd7ba7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd2e7beb1cce97e5d0c94d7fc44c70393ee6ca4788332b3329ebaf6a88086840"
  end

  depends_on "pkg-config" => :build
  depends_on "zig" => :build
  uses_from_macos "ncurses"

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
