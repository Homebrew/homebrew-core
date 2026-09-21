class PfetchRs < Formula
  desc "Pretty system information tool written in Rust"
  homepage "https://github.com/Gobidev/pfetch-rs"
  url "https://github.com/Gobidev/pfetch-rs/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "571d339ad29561bdc510c09f3cac2bb0b8dc619b3528db68915e5927e70c5988"
  license "MIT"
  head "https://github.com/Gobidev/pfetch-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "34621ac07a02ce1cbd76bd1ff05ef65a8bc9c16540c7387d543b99082cb0331a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ddf452e9e892adffa62d138f3b7b43f6ea678a2598701e5c30d568a8d10cc82e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c183ea8fd78ad9ac96741f71eeff4bfd56df97e940d5d3131e61edad38dfcc29"
    sha256 cellar: :any,                 arm64_linux:       "c7ebd68eac76239455561dba7d1155f2326d83566b1958727298698fbb070d25"
    sha256 cellar: :any,                 x86_64_linux:      "ef6aa6a9230d3bc3368505c9edcf1f270bf35e29b93fb7a56d1903d6c0f4a774"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "uptime", shell_output("#{bin}/pfetch")
  end
end
