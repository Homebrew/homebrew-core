class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/cloudskiff/driftctl/archive/v0.5.0.tar.gz"
  sha256 "6fc0643a854ecae4a5f584b88acb258c468c465dc4c9ee30e11014c539458367"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "6ce84db98668856da064b02bca101ba46cfd3c6f2b56bbecfe63f8f18a3bd5f9"
    sha256 cellar: :any_skip_relocation, catalina: "c8ed583db406959d47ab2357b01d8dd5bda5fd19eccb7e37f527411fc3c31454"
    sha256 cellar: :any_skip_relocation, mojave:   "fed10c3cdc6c07c6721ddf26b66484295d0f710ff35339d0bdc3997360dd8c5e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X github.com/cloudskiff/driftctl/build.env=release
             -X github.com/cloudskiff/driftctl/pkg/version.version=v#{version}",
             *std_go_args
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/driftctl version")
    assert_match "Invalid AWS Region", shell_output("#{bin}/driftctl --no-version-check scan 2>&1", 1)
  end
end
