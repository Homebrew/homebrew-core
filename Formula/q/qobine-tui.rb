class QobineTui < Formula
  desc "Tui player for Qobuz"
  homepage "https://github.com/SofusA/qobine"
  url "https://github.com/sofusA/qobine/archive/refs/tags/v2026-07-21.tar.gz"
  sha256 "8beda8cf9a78ef02f97f8ed2c3649cdc04bc551dc2d8db5552f9bba89c52fe7e"
  license "GPL-3.0-only"
  head "https://github.com/sofusa/qobine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6ec9727822271e8e20465414f7ec126419892e324af1ce08860d28d9273508c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50af8cfb8100351eebebd33032b536cd05229affdc06898bf795dc8f3ee2e6da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "383560eacc68a20faeea1c0e8d240848454930d69ab0825984857f7716d10020"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7580d7d0a516713162452836acf1db499ccf738ae41e668b2e53d2930901154"
    sha256 cellar: :any,                 arm64_linux:   "8bd35d15b91af10e4a051d2703a82a6c69eab06776a58e3ed954a9214158089b"
    sha256 cellar: :any,                 x86_64_linux:  "1452fe56715791f29eef5a8e91fc92f5cc0e98591a9cfa4137b1ee4732618cf0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "openssl@4"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "tui-module")
  end

  test do
    _, stdout, = Open3.popen2("#{bin}/qobine-tui login")
    assert_match "Login to Qobuz in browser...", stdout.gets("\n")
  end
end
