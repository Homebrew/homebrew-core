class Cot < Formula
  desc "Rust web framework for lazy developers"
  homepage "https://cot.rs"
  url "https://github.com/cot-rs/cot/archive/refs/tags/cot-v0.3.1.tar.gz"
  sha256 "864f222df38563aaac0cb87d1866ba929c76b62b33b6a50497bf010f3053eeff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "adea33aaf2c5f5880be1781fde8ddcd10a8e88c6ff61c76610627c4725dc7236"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a0ebd1d7e41a7c0e9850d9e4008724e6d9f179b03f48837f734a2cd39b08292"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "86c391ffa3164c7528eb72b603eec9781844a5d8c1c2b1681a421c6a2fdcf4a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "42bbc1bb3a9ca8270ceea2f5101aa41e4d62cddb5ad2ca2611f885f6168e819f"
    sha256 cellar: :any_skip_relocation, ventura:       "30b1e9be7ad094560fc5bfdb733988ae9c065d89270092c95ec6ae330fc23335"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "628bf486df5b8511197b1a1a996d22aeb7b3dd8d6f0a3012c33fa78b983847a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a346bf885aad13634135870685eac98467fb302065b1e5967e9152e5d43a08d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cot-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cot --version")

    system bin/"cot", "new", "test-project"
    assert_path_exists testpath/"test-project/Cargo.toml"
  end
end
