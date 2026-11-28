class Iodine < Formula
  desc "Tunnel IPv4 traffic through a DNS server"
  homepage "https://code.kryo.se/iodine"
  url "https://github.com/yarrick/iodine/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "9c1017dc9ede3a4300ce3026d98b502897e76ae93072ae5045d97b169516f84b"
  license "ISC"
  head "https://github.com/yarrick/iodine.git", branch: "master"

  bottle do
    manifest_sha256 "4c7c9a0678bd68419457fafd0c409cfa9e7c89851fc8e875e195e1a3f26b57d5"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2fe4405a1a0581ad167dde750fa8d10563247b95a6b939715c950328f7695c2b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d3dfbdd4a60cd1e1b8fd1b40690e70ef559a39602c1e7f5b098746ebe1704842"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f48b20fbb015a1e342b58a61b2296298cf44c5a8508c8330ebde7238a5f164ba"
    sha256 cellar: :any,                 arm64_linux:       "53e4519e844d319a4e2ca48c5bac06d39717989db5099571e23a4e8cabec1d2e"
    sha256 cellar: :any,                 x86_64_linux:      "9b137f9a738afc4411d82915684362f4a448e66bc9ee8b33e8422503443e3e6c"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # Both executables require root.
    shell_output("#{sbin}/iodine google.com 2>&1", 255)
    shell_output("#{sbin}/iodined 10.0.0.1 google.com 2>&1", 255)
  end
end
