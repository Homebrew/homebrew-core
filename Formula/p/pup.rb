class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://github.com/DataDog/pup/releases/download/v2.7.1/pup_2.7.1_source.tar.gz"
  sha256 "11924393feb2e32ce4e69a1a2f817c35a6eedd597be4bb0e3114dd23b95cf75c"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    manifest_sha256 "301fee4112fd266cba7ac32d00156a60a7c04f5848fd6bf98576cd1f693406fc"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "14eab8e24b0d9ccfcfb44799c3e08afe3a26627fb9f22d2cf418245de4d85375"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1526d1820f4bbb9681272fd92999035b17817902dc37a92b42ee1cfabcf722c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2897c88a124da8c82b9a6f4964e676c8db289c31f577441637e8a8b91485ebe0"
    sha256 cellar: :any,                 arm64_linux:       "3406f31347039651e7d62aaedeb047f8b4ce4f02c68e2f1f49df82f119e50559"
    sha256 cellar: :any,                 x86_64_linux:      "e6dd0c501a521b32e68f5149116072efa573a5e0eefba524b10ac3dfbdc7f5bc"
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
