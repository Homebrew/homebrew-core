class Ocm < Formula
  desc "CLI for the Red Hat OpenShift Cluster Manager"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift-online/ocm-cli/archive/refs/tags/v1.0.14.tar.gz"
  sha256 "42f1777ca8ca052331141b50f4d40da5c64accb1306c50d6a768c2c6978aa2ad"
  license "Apache-2.0"
  head "https://github.com/openshift-online/ocm-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac7831e4992bbadbaa36c10c5a7aea566c8d4fce9612dc98480254f7e6bc5c20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "feb00828135901e08a9dd7cd430e95fdd685b56ce1ab197178cbbcccc23afecc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a24d15c5897240c606cdc1f66b565ee9d1128fbe28ed774aef3356046daa5733"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c607c66befef2b238ebe29f3e028f343d7f1caa7571ebfe925e489b388042f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2242b9ad91d0241debc1cdf536bf646af02c97eaf1fb203afe3be99c0236d679"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e6ee17e3ecf4e43980e8577abbb25c80c3a28d7985d3d504e9a012c55071a4c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:), "./cmd/ocm"
    generate_completions_from_executable(bin/"ocm", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ocm version")

    # Test that the config can be created and configuration set in it
    ENV["OCM_CONFIG"] = testpath/"ocm.json"
    system bin/"ocm", "config", "set", "pager", "less"
    config_json = JSON.parse(File.read(ENV["OCM_CONFIG"]))
    assert_equal "less", config_json["pager"]
  end
end
