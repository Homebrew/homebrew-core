class PfetchRs < Formula
  desc "Pretty system information tool written in Rust"
  homepage "https://github.com/Gobidev/pfetch-rs"
  url "https://github.com/Gobidev/pfetch-rs/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "1584dc6a8092b9f621b95fcc98b6d011b07d7249cf4156a9355d6a8bd131acbf"
  license "MIT"
  head "https://github.com/Gobidev/pfetch-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "646a13f5ad25eb5b09137fe1e511040a1ab5eba93cd9013a10d2ac22fc16e0fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a395bec28c83835b95e9514378de09f70c272064c754fab429c0cddf826dbc71"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e46db0149f1197c5f9be08ddef1e8f67318a3dda6efb5987d2f5a912e2ed3cfd"
    sha256 cellar: :any_skip_relocation, ventura:        "14daeec7fdb56a8046feb8268b34e72eb2bc989666688764b0d4a1c7633709ce"
    sha256 cellar: :any_skip_relocation, monterey:       "307bc5649be4d979cc00879898ab52ade79e11b651d0931ebd5fb2e139396c3a"
    sha256 cellar: :any_skip_relocation, big_sur:        "e096d53f0c0ef43cbd5d22a561ab9ee3b72db142a7dd0cc0b200b746c35069a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a0fd9355be8d48036af7c07bc4d28e81bf43d3e3acb7206680a644ab6e0aa24"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "uptime", shell_output("#{bin}/pfetch")
  end
end
