class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https://github.com/Macchina-CLI/macchina"
  url "https://github.com/Macchina-CLI/macchina/archive/v1.0.0.tar.gz"
  sha256 "98df09568a7178fb97dcf27108eced0ed1018aab519c132b17e6b3b35e966a50"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6513b4c13754f0a1e987b0eb973dd0838a84b52e201c2a83c3f8927d452c62fd"
    sha256 cellar: :any_skip_relocation, big_sur:       "c867963a1f4da0ad388c04f2e9ad0ff321b01ade266cf6ff265759a9141f428a"
    sha256 cellar: :any_skip_relocation, catalina:      "fb2a3cdb9c7b7a016587a0261698a5175e71772692a78753d74abd8545b1c657"
    sha256 cellar: :any_skip_relocation, mojave:        "0d2fe76fc227fb46261611d6fb7ecabc0cd3d9f48b126747dfda1bfd39c4a898"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ccc7fa30ebe1acf5350810af00c059c5b4a5392e907b14bb48186a5e0ee8997"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Let's check your system for errors...", shell_output("#{bin}/macchina --doctor")
  end
end
