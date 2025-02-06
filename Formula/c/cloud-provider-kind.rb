class CloudProviderKind < Formula
  desc "Cloud provider for KIND clusters"
  homepage "https://github.com/kubernetes-sigs/cloud-provider-kind"
  url "https://github.com/kubernetes-sigs/cloud-provider-kind/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "ba3fad794370b1ff14e608edfa5883cb455e1e6e89d6a63187c5f47bf4e23251"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cloud-provider-kind.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82743514320e02d3a5bd8fb46b9e8e4e8c39e0b71270b998559c930d3a85061e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82743514320e02d3a5bd8fb46b9e8e4e8c39e0b71270b998559c930d3a85061e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "82743514320e02d3a5bd8fb46b9e8e4e8c39e0b71270b998559c930d3a85061e"
    sha256 cellar: :any_skip_relocation, sonoma:        "597af62080bacddce17502631e2513d4846873be929c2792c7264368ced03d74"
    sha256 cellar: :any_skip_relocation, ventura:       "597af62080bacddce17502631e2513d4846873be929c2792c7264368ced03d74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5545b87301dda62fe2db61748cd20f8560777c781f1333c769b23d77dcff92a6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"
    status_output = shell_output("#{bin}/cloud-provider-kind 2>&1", 255)
    if OS.mac?
      # Should error out as requires root on Mac
      assert_match "Please run this again with `sudo`", status_output
    elsif OS.linux?
      # Should error out because without docker or podman
      assert_match "can not detect cluster provider", status_output
    end
  end
end
