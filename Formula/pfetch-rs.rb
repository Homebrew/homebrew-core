class PfetchRs < Formula
  desc "Pretty system information tool written in Rust"
  homepage "https://github.com/Gobidev/pfetch-rs"
  url "https://github.com/Gobidev/pfetch-rs/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "b21a91a9536ca776c38541e3d79a6c8fab4b522db0ef15353cb11e0833e7d3f7"
  license "MIT"
  head "https://github.com/Gobidev/pfetch-rs", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5303f70adbc4e091a65f6d6a43b38c9edbcbb40737fca7bebf7806031b7fa7b"
    sha256 cellar: :any_skip_relocation, ventura:        "5e28f8eb863297236cc96bfea887675b1574ff5d6b303855b9f58099d840a430"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a1422f9d9d368a0fae51458f38c02f323b6e5a6027e1a81bd1813fe78a0b405"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "uptime", shell_output("#{bin}/pfetch-rs")
  end
end
