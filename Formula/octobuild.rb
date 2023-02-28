class Octobuild < Formula
  desc "Compiler cache for Unreal Engine"
  homepage "https://github.com/octobuild/octobuild"
  url "https://github.com/octobuild/octobuild/archive/refs/tags/0.5.1.tar.gz"
  sha256 "dea1ace397905d2a4bfcb4ff53acfe90a27a039a975e0a6d1b243a8513860662"
  license "MIT"
  head "https://github.com/octobuild/octobuild.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16b06b1d17d8a4e0e4ad1f8ad3cf2c7d01ae5350f8f1f0b8c8aef6d39777c53e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c6a442f62b6b5844ee7914d2a0f360faa9c0b94498dc5f864673839d0fc543a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b646963df6369c071f51b6032ffad2b3fa4e4b7b31746ebdd519c954958f590e"
    sha256 cellar: :any_skip_relocation, ventura:        "28f54605e29c14b30014a52ce3b0a85ee7e1f07dfb20a24b0f1ce3fc8c40355a"
    sha256 cellar: :any_skip_relocation, monterey:       "95429641e293a79364368bdc74fdb094c70a13804546ad4b577c82b72312c4b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e641ac4b700eaf44fb219b086a551e2a0aa52584e7edbf93a723188fbf74c90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87767afa0dfcb7f44b084c726bcf06ba11f56b8bb17ccf63f3a6be055e78dc50"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output bin/"xgConsole"
    assert_match "Current configuration", output
    assert_match "cache_limit_mb", output
  end
end
