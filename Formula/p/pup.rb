class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://github.com/DataDog/pup/releases/download/v2.5.2/pup_2.5.2_source.tar.gz"
  sha256 "340a26745aa3b1ea68b044d5bf884df0d2569f93a6cb7460d5bd55e8ec38d81e"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5265854385ef002868905f16bfe345a10500f208d8fd62c0ccf4a3d8765390d5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "873b90f7fbff7144939ebb9947442cc1a8fcc697ea69776c0b19488581caaf58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b41c85613ff7672ac5ba283ebb9eb2b7c27cbb4b7095d6f106f4c2c278b0ece4"
    sha256 cellar: :any,                 arm64_linux:       "0b1f888e7696ff1ab182e7d47aa49f9febb102d154f1f6a18d3815a0c14c8184"
    sha256 cellar: :any,                 x86_64_linux:      "4c93e732202721841d3831a14044988f71e840f6a84535cb2c40204c06fb7faa"
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
