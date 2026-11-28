class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://labs.iximiuz.com/playgrounds"
  url "https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.117.tar.gz"
  sha256 "5c35a7398be6d60594932e75185e3cfa4c7285b225c8644dc050a61df25c7c9b"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "f9755e7be73058aea65f7861a771c06f917be477d470151a1595a94c804d8c0e"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b0e333fc504ff306e3c1223b4c2cfa993cdb68926b9c57199e220e8f50754cd1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b0e333fc504ff306e3c1223b4c2cfa993cdb68926b9c57199e220e8f50754cd1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b0e333fc504ff306e3c1223b4c2cfa993cdb68926b9c57199e220e8f50754cd1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ce460048076efc7b211ff98e6f50026622cc190f4cf08937f4922c4e1be1f200"
    sha256 cellar: :any,                 x86_64_linux:      "b954ee5891000b20c8948577b6fd625fbbc92d33a1f34734fc934b6e138eae08"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/labctl --version")

    assert_match "Not logged in.", shell_output("#{bin}/labctl auth whoami 2>&1")
    assert_match "authentication required.", shell_output("#{bin}/labctl playground list 2>&1", 1)
  end
end
