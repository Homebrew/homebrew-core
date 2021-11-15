class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https://github.com/Macchina-CLI/macchina"
  url "https://github.com/Macchina-CLI/macchina/archive/v5.0.5.tar.gz"
  sha256 "f8cd45546f3ce1e59e88b5861c1ba538039b39e7802749fff659a6367f097402"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "287ed38e068c0e828f62585c991de91755e22aaced7049111a10624d92ef4633"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa832a1ca6709f1b8cb727eacca232b355962133a72693c4f83284a4e5ca2b7b"
    sha256 cellar: :any_skip_relocation, monterey:       "311bc5e1f22a509234258049fe3e8456362c1a76d7ac50103ff3ccd59c19833e"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f353c38f5f70a1a2120911ba8d3238bf6214a86c3017a450f5cb53ea70ff490"
    sha256 cellar: :any_skip_relocation, catalina:       "0ca50b7cb21df0b753ad88f4406fe1d82f2c587226ca52c1cbbb3c36a4e7a4f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c098962b2620cbc5365a43c9ea8defdf678f35338716fa65fef750c055639360"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Let's check your system for errors...", shell_output("#{bin}/macchina --doctor")
  end
end
