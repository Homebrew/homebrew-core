class Iamb < Formula
  desc "Matrix client for Vim addicts"
  homepage "https://iamb.chat"
  url "https://github.com/ulyssa/iamb/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "8e919c19ef90f328d20e6e46720a26f0dea6e61901b8180fedbbacb473f131f1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8d54a8ad85db5e100b469ecf99707754a5174456d8c39e553430a288fb3764d7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "869e4d57684b2085f6f0da9e7f13281a134f34e0c277aeb547214063c0a073d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "70289892d0fe9f3b0b763e6d64a4c16ce14398e2ce6b3fc7d23bdc3e4e55290a"
    sha256 cellar: :any,                 arm64_linux:       "b8933aaa51bf94c66a246ee8dce08d2209afd8b6432e91de7181af4f7d33d9bd"
    sha256 cellar: :any,                 x86_64_linux:      "5041d7cdab2c107c811e0ef08e38ec1202bb86accd5cf33a8349179d431bfd64"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "sqlite", since: :ventura # requires sqlite3_error_offset

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["LIBSQLITE3_SYS_USE_PKG_CONFIG"] = "1"
    ENV["VERGEN_GIT_SHA"] = tap.user
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Please create a configuration file", shell_output(bin/"iamb", 2)
  end
end
