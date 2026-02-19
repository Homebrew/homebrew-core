class Dnspyre < Formula
  desc "CLI tool for a high QPS DNS benchmark"
  homepage "https://tantalor93.github.io/dnspyre/"
  url "https://github.com/Tantalor93/dnspyre/archive/refs/tags/v3.10.0.tar.gz"
  sha256 "31429fd7aa95440509850e174bc932b7d33aed8be687d90904129c95f73da715"
  license "MIT"
  head "https://github.com/Tantalor93/dnspyre.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e99c303e223ea38d4d81b70ba1085c4b03c76a7fd7274419805222a04be1d2c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6eaa9389813c7083a112cf47a451418f1fc76d6bd8f9f8fa39537727530fa375"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41d33cb63a20d560f2f91dd14bc91ba2680d3744a1777d275f5106cc7335660a"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb9f02ecd9931b94f9494d753f4a25e30aa2064d32691e6f2ba936913f37c048"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef1e08f84d494dc4a16d2af7d6bfdc11c254bcd539f989ffef907b340bc0231f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfcf239159bebe0385d21be1dc0727a42c4f20efd6155a56ac72d5b7157a6144"
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
