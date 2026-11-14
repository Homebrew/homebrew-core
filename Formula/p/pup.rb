class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://github.com/DataDog/pup/releases/download/v2.4.7/pup_2.4.7_source.tar.gz"
  sha256 "752c71cbf8d4d2e31aadb87b4c49d47e24c059b1572fc35880f853c1ea232739"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "afbbb3bedbb3282ca1aa73344a7c8877a2f70e999b46d101d893e2ed3f6c18a1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "06473de648281686626adfe957cd2d6ac67797898bbc382ce8895df3775e7558"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "749e0cd9b9d7679018e97c07da5c67d8e63fd7024a8a20823b8760dfe93ac53e"
    sha256 cellar: :any,                 arm64_linux:       "d8e276b276e1d7012d1a8a5182aa8594e41cbf5ff8cd625f354f49a7f8ed59f2"
    sha256 cellar: :any,                 x86_64_linux:      "bf2a96c4fbb359fe29329723ec3af7fe567ac85a805fcb866c37c185dfbedd64"
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
