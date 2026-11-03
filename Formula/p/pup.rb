class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://github.com/DataDog/pup/releases/download/v2.4.1/pup_2.4.1_source.tar.gz"
  sha256 "5fd7945154f0b802933b563facf436d466ec599dafd6a2d6883cabfae9cf80e3"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "448b4955ed828088a3a9e94868ec2893e3390d89dfcb7a9a7a414cf321467293"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "622aebbe4df44f14c5ca0c0ae2763c70fd807bf8806918ddd9601f825afa6afc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d197f8d4e38db47e878cfa470a7e1ed512e5d35d51c19e80239a04a127139cc5"
    sha256 cellar: :any,                 arm64_linux:       "8a88a1ede87aae4cccd388c55d3de8e17fb7ba4d729f987b9b4a7535d9d7f9db"
    sha256 cellar: :any,                 x86_64_linux:      "5957f1e039fd63d4f9825035732d7e70760bb9b485e1a11773cb40c4acdaced8"
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
