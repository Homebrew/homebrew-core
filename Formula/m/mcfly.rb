class Mcfly < Formula
  desc "Fly through your shell history"
  homepage "https://github.com/cantino/mcfly"
  url "https://github.com/cantino/mcfly/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "bfb6ca73c6a03047e3c61edf2b3c770e24ddbb0720e2a7dad3ea13a759572bb6"
  license "MIT"
  head "https://github.com/cantino/mcfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d2ef4c04d2447315ff42c4a8507d3523001ccac08ef87565419a666f33300c7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "55854b95297ca2160ce80bde27eaedfe75f2fa19459619922ddc3a7bcd494cf1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "705fb8c356ed1350d6ddd08497d6c31a5ecac6e2a83d87477adf4af0bc47224f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7503ca23d5f95900b6e08ce5dafc4124b56d7a0e5aad08434a5b98e72f5536f"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe78e7f12b1e2b96324f7a812cda5d7452cfd1e27ba572c3d04771ab51d37474"
    sha256 cellar: :any_skip_relocation, ventura:        "9e1585ab4d9ad2fac90c1120f3c29067bfbc023dd644186bcb87e6efbc5c9ab5"
    sha256 cellar: :any_skip_relocation, monterey:       "f5acc675a5f1b3530c61a813749085ecc956b1278f83c9c4e424765b3c447b64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66d9ac4a4e4b41c3f4c86b7d894bec633ed22ce69e10a82836303ae2ad021a0b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "mcfly_prompt_command", shell_output("#{bin}/mcfly init bash")
    assert_match version.to_s, shell_output("#{bin}/mcfly --version")
  end
end
