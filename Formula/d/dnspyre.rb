class Dnspyre < Formula
  desc "CLI tool for a high QPS DNS benchmark"
  homepage "https://tantalor93.github.io/dnspyre/"
  url "https://github.com/Tantalor93/dnspyre/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "0209904c728c6f844a1d9b8e63c407b01a377b7354171cb082d3e503ee81b90a"
  license "MIT"
  head "https://github.com/Tantalor93/dnspyre.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a674c91cf8c84681530709612d7690c8d05e50c910b77b6034e8da28a2338bff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7eeeac56977d561d9ed4173b3be35f535a29319a25a5dd1ef54f2c3390bf082"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3f8407e55d90a2e053a7cab549fbb905e3eccaee84b76a1941f542a04741e64"
    sha256 cellar: :any_skip_relocation, sonoma:        "48aea410721a3fc68ae772632d055865d69e10136150c66e7e743648b31456d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d713d18febf48e77c9a6412b6d2875c136c183160c3ce4fab99e67ceafc959f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ccf0089124d87995945d3bda85545b1b58b66268fbe9e66c5c746145710854d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/tantalor93/dnspyre/v#{version.major}/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dnspyre --version 2>&1")

    output = shell_output("#{bin}/dnspyre example.com")
    assert_match "Using 1 hostnames", output.gsub(/\e\[[0-9;]*m/, "")
  end
end
