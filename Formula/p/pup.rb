class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://github.com/DataDog/pup/releases/download/v2.5.1/pup_2.5.1_source.tar.gz"
  sha256 "a3db456b8b0e2cc88e32436d26459b81a25d34f7cc1896b9d17a01129daba93f"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "03e5799105713a9336d337918b3746009139c120ed5263793c16e795c269a3d5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4480c7ea20aec7485451ea789705f540e3da855f93f5ee7e87492afc03c8afb3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "18b3f5cf4da52ce9ad64fa87244b0bcf23617623bdea43588dff89b718dc4c81"
    sha256 cellar: :any,                 arm64_linux:       "c47483d99ce974a0acc985c0739729984531fb6db9244be95de1ef839e450d36"
    sha256 cellar: :any,                 x86_64_linux:      "8e6ef5752d13f2a986ff848f91d8a587caf93c8d86e74e998c990b8311a99e30"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pup", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pup --version")
    assert_match "Use pup CLI or generate code", shell_output("#{bin}/pup skills list")
  end
end
