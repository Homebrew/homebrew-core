class Lemmeknow < Formula
  desc "Fastest way to identify anything!"
  homepage "https://github.com/swanandx/lemmeknow"
  url "https://static.crates.io/crates/lemmeknow/lemmeknow-0.8.0.crate"
  sha256 "6a84dc3c9c3aba3b43b2bccec7ff9ca15ee94e6644eac129fef1ffd13d9e4733"
  license "MIT"
  head "https://github.com/swanandx/lemmeknow.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bbd5caa47337d9d89b1a32257355c58d26259d109f0ac62ac485b60b7b3928e2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dd7e90d4fbfdd91179118b0ac0f295c678ede8f73e98b3e447921a1b21909e29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ee4a88135c29b58734a0bbf5c5a6ab42225fc93392a570a1ee1e05390a8374d8"
    sha256 cellar: :any,                 arm64_linux:       "7d52e188519eea85e2186850161b40456c46e49acd51b7aefbb25453b5196a48"
    sha256 cellar: :any,                 x86_64_linux:      "01421886120d3c39ed335bda5dd37b30a89f30b5b8c4f71eb56c82e4a90dff29"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "generate-lockfile" if build.head?
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Internet Protocol (IP)", shell_output("#{bin}/lemmeknow 127.0.0.1").strip
  end
end
