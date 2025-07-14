class CloudProviderKind < Formula
  desc "Cloud provider for KIND clusters"
  homepage "https://github.com/kubernetes-sigs/cloud-provider-kind"
  url "https://github.com/kubernetes-sigs/cloud-provider-kind/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "0dd74003639198dbb6742987410c7eb5365e7bd2d46ded1d22a5ce8980731195"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cloud-provider-kind.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fb19eab6f4cff790d8c78249b58139462a3d9090837d40c4b8e2f886869a1cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b46a3770258576c9b690066bdb1bde3205bf4a845495dc9931a3fdf39df04e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "07c500427b5660c360bf3839e352ec64431e0934be5eaa0f7c96b0f72b109202"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c9947498d2552ed15df2f150a58d4c0f1222ce5685aa82b94a1fcca55a13061"
    sha256 cellar: :any_skip_relocation, ventura:       "53d6080c324e2d38069b5ffd4d158fe67c4e6eb2309a5809161967551f54ca76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18b0f8c3571a8b31aef96e6f0b1794b0fb90eae733211bfbe28076e6834183dc"
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
