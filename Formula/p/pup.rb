class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://github.com/DataDog/pup/releases/download/v2.7.2/pup_2.7.2_source.tar.gz"
  sha256 "e8a3c2ddb910a95be2a6343e669cf0785788c2e8a0c5d5b6b8401e91ba04a6db"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    manifest_sha256 "2ce4091653f850c93c271f69ff22e028242117c9e9a763505a4729efb2819c9d"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "78d9ba4daca1068fe4ea1b3ad0fcc5d4a011852454f9ba9b19bbf121fa9d49e8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bb9efd4ed77be5da0d19a4b23564d0c706b7f1d51591092714edc29ea3f9be8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "459773e6503a57de011bbb40672700183d74e3e6781ee1770e4ec7ee5e483637"
    sha256 cellar: :any,                 arm64_linux:       "c37a2497cd3ce2ba0d9e446cdb48506c665aec9923a43bf463f6dad98506f803"
    sha256 cellar: :any,                 x86_64_linux:      "7b0172e25d1df496668167ef782158aacfc9986d6acb52830dfaea25ee9b593c"
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
