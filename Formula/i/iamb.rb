class Iamb < Formula
  desc "Matrix client for Vim addicts"
  homepage "https://iamb.chat"
  url "https://github.com/ulyssa/iamb/archive/refs/tags/v0.0.9.tar.gz"
  sha256 "7ef6d23a957bfab62decd48caa83c106a49d95760b4b2ccf5a6b6a8f4506e687"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df5468418a4a4af000aff2ab762e155d3839f52ee0c8f0c95fd5819cecee2a79"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d9f06178e7513c05362bdfd4c8c213f0fe8ec31fc7c831d04b371b60e6f8e2e"
    sha256 cellar: :any,                 arm64_monterey: "c928e483bb98d810c0198ebfb8f5fde3ea763da5fb279069aafaa8dde9893e71"
    sha256 cellar: :any_skip_relocation, sonoma:         "070fdce3fb47521f17d979d6387b40a2338cda0555690c5bfd9bcb611ccc8cb3"
    sha256 cellar: :any_skip_relocation, ventura:        "a72b6c388f13df9814173ed6b8f7980afc4d7d3f1262c694f9a94d7cfd614941"
    sha256 cellar: :any,                 monterey:       "8244a873a5bc029bf2f359594ad64ede6d647ddd827a7cbc49b8232cf9c51ec8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b630ded350a73202b2d7d2813ec8d28889351186cb4281a3f232b0fa6214f6ef"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  uses_from_macos "sqlite", since: :ventura # requires sqlite3_error_offset

  on_linux do
    depends_on "openssl@3"
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
