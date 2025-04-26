class Goku < Formula
  desc "HTTP load testing tool"
  homepage "https://github.com/jcaromiq/goku"
  url "https://github.com/jcaromiq/goku/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "52a95fa94b808d2c93bc875d78278abc2d9bb9da373d6782f0d4e08394eb6c99"
  license "MIT"
  head "https://github.com/jcaromiq/goku.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b0433fb67b204f465869f46247110db4ce45d825e8113a7eb19e10ef6c41c58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c59d8ce791678c1539fbc9576efc75b6aa4b6a1e2f6f18a0fb961ef8ea31e7fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f995b45c3e316860001ce711e5ad339e18e25ac89898ec7a3ba0cc7b378fe2aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc0de507a1b8ab91033c777f20bc62596acd84bec402a6e15013866818cc81b2"
    sha256 cellar: :any_skip_relocation, ventura:       "0b562227e21b9b34cdce8798166f08ab67f692d1c58faf42c8e06625f14004c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c0c3f3eb4ed12f83c1d8791437de8344d1a8b5c4347a9d384ac53b98ca3c269"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52ca9ed29c403fee3de04093d278d1c413a99334d5781772bd7920f2f92690bd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    output = shell_output("#{bin}/goku --target https://httpbin.org/get")
    assert_match "kamehameha to https://httpbin.org/get with 1 concurrent clients and 1 total iterations", output

    assert_match version.to_s, shell_output("#{bin}/goku --version")
  end
end
