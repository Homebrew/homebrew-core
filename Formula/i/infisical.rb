class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/infisical/archive/refs/tags/infisical-cli/v0.41.89.tar.gz"
  sha256 "9adff41ed468ba2dfebfa1696233403c90a4888205fe095fdad79c91eb0409d8"
  license "MIT"
  head "https://github.com/Infisical/infisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99c92397cc538d78089997b8a9519097e85e9689a0dbb99d4ecc5c26d3f82d48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99c92397cc538d78089997b8a9519097e85e9689a0dbb99d4ecc5c26d3f82d48"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "99c92397cc538d78089997b8a9519097e85e9689a0dbb99d4ecc5c26d3f82d48"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf46b98ca945734960d2bb6734db9aac71e37f7188e11caaacaa47574ea168c6"
    sha256 cellar: :any_skip_relocation, ventura:       "cf46b98ca945734960d2bb6734db9aac71e37f7188e11caaacaa47574ea168c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c6c367dbc4f41e0a13ea592cab75727c44fc22d31ab10d453ce1cb74b40df23"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      ldflags = %W[
        -s -w
        -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
      ]
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end
