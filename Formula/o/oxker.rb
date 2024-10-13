class Oxker < Formula
  desc "Terminal User Interface (TUI) to view & control docker containers"
  homepage "https://github.com/mrjackwills/oxker"
  url "https://github.com/mrjackwills/oxker/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "4816f0bb05650c91f33859c7de7a2c062465c7c004f89487866c738bbfa03cd2"
  license "MIT"
  head "https://github.com/mrjackwills/oxker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "40f2bd2dafee7f99d5ad223b6945bca3cd96d230a4f653d17868694249de46f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c4171754557d54ed6b5a99ac064cbcff6d0d59b013af3c3802b39f731a1e04f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a6901453ba40795f9cd79d517e2cf8aa6c0d235f0eb431acc8748c1557e1243"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61012f64f36aaa4f8845108ccc695234722fa873f27ba4dda815223126780630"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f8dd27a0021b0c678f51e63a7b3cbf35e098205cac6045ebfce16aa967b4f5b"
    sha256 cellar: :any_skip_relocation, ventura:        "a44e370143620a281ad18238419eb959dc285a5945d269943a441d030c7b6806"
    sha256 cellar: :any_skip_relocation, monterey:       "c1ecd97f6733761a4398ff56cd217c1609dfc83ff4e50731783c839c551d9e38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec10f68b9055b330ceb2c9c7a562039253634a413f2d2c895fef77433355eb7d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output(bin/"oxker --version")

    assert_match "a value is required for '--host <HOST>' but none was supplied",
      shell_output(bin/"oxker --host 2>&1", 2)
  end
end
