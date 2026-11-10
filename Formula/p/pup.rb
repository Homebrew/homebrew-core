class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://github.com/DataDog/pup/releases/download/v2.4.3/pup_2.4.3_source.tar.gz"
  sha256 "ab3d4e28ec26556c9aa10fdaf375f7a450b4090dc5a0f8918a24c50572012fff"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4b7389fae403406bf8b89e9dee25156430ee58be9817aea1dd24882cca392c6c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bdec49fb6b22ee031086986fa1b82164f3a5a14c156d3b20cc1dda6af82b7aac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f41159b209927c491014979ad537effa235919dff6852e6689fe5f47545892db"
    sha256 cellar: :any,                 arm64_linux:       "5209f47c06da9e2f60390ad07e1a674d995ecccdeb913d7c9390b5e09486f0b4"
    sha256 cellar: :any,                 x86_64_linux:      "e662bbe475a940453f9a0015a75bbffff895d64de5aa427a93bd947d748aa1b9"
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
