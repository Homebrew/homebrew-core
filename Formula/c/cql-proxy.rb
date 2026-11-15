class CqlProxy < Formula
  desc "DataStax cql-proxy enables Cassandra apps to use Astra DB without code changes"
  homepage "https://github.com/datastax/cql-proxy"
  url "https://github.com/datastax/cql-proxy/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "41a6d8a65446f2cb65b004de561adccae58a2066119c21e0fb24bf3999dd58c2"
  license "Apache-2.0"
  head "https://github.com/datastax/cql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "50eb31072ba68acb4dc85fab963bf941b3c7358f800ba6c64e56b2f270c9c898"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "50eb31072ba68acb4dc85fab963bf941b3c7358f800ba6c64e56b2f270c9c898"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "50eb31072ba68acb4dc85fab963bf941b3c7358f800ba6c64e56b2f270c9c898"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "50eb31072ba68acb4dc85fab963bf941b3c7358f800ba6c64e56b2f270c9c898"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5b333e252968e5388e7c7e3e40d60c9dbd19a6b4f5f3727a0c009d6bb00adc9e"
    sha256 cellar: :any,                 x86_64_linux:      "e5565236a72be7f9b41861b6887ea01ca9ac94627c43bcd2965fbea95a389211"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
  end

  test do
    touch "secure.txt"
    output = shell_output("#{bin}/cql-proxy -b secure.txt --bind 127.0.0.1 2>&1", 2)
    assert_match "unable to open", output
  end
end
