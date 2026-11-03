class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://github.com/DataDog/pup/releases/download/v2.4.1/pup_2.4.1_source.tar.gz"
  sha256 "5fd7945154f0b802933b563facf436d466ec599dafd6a2d6883cabfae9cf80e3"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "da9da76986cf8340852c003695e6b5f9490f119dac87cecea9d4c4f2bdb42694"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d3300497502ffb8d8c1a8fb1f901454c03be4bbc0149f0e88c6841d07c6f173f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8612c7883c38e2f57cd527b823e2355a96590d10accdd542beff752768306b72"
    sha256 cellar: :any,                 arm64_linux:       "1a80f3e219cf2ce15cf3ffb653ef0c51423ec7ae77d35320526f27d703920fe3"
    sha256 cellar: :any,                 x86_64_linux:      "03e43fd6a03336c0d1c4e3d7f4ad9ca230a8aae240b866a86b935fd39e8818e8"
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
