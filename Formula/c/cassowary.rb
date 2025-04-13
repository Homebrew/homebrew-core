class Cassowary < Formula
  desc "Modern cross-platform HTTP load-testing tool written in Go"
  homepage "https://github.com/rogerwelin/cassowary"
  url "https://github.com/rogerwelin/cassowary/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "28b02f314295ebdfc4577f8c06f23fc3d48ed195ddfebc95d5f42343b37b9e52"
  license "MIT"
  head "https://github.com/rogerwelin/cassowary.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e2eb51373cef3390b372210eef8c12d5bf8f15d3fc04877e6fbde07921f1744"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e2eb51373cef3390b372210eef8c12d5bf8f15d3fc04877e6fbde07921f1744"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7e2eb51373cef3390b372210eef8c12d5bf8f15d3fc04877e6fbde07921f1744"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d0bce4e9a3d9eba906c6b360c30633c8425ef78a472341bfb939c9e920bfcef"
    sha256 cellar: :any_skip_relocation, ventura:       "5d0bce4e9a3d9eba906c6b360c30633c8425ef78a472341bfb939c9e920bfcef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc23f86df8f47a7d4f755acd9dadab662e16b39c70008fdd10e89a8b1314c093"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/cassowary"
  end

  test do
    system(bin/"cassowary", "run", "-u", "http://www.example.com", "-c", "10", "-n", "100", "--json-metrics")
    assert_match "\"base_url\":\"http://www.example.com\"", File.read("#{testpath}/out.json")

    assert_match version.to_s, shell_output("#{bin}/cassowary --version")
  end
end
