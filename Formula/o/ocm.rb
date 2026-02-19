class Ocm < Formula
  desc "CLI for the Red Hat OpenShift Cluster Manager"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift-online/ocm-cli/archive/refs/tags/v1.0.11.tar.gz"
  sha256 "7d1e419b7a1c999c6a7387276b90ed288e878c75d2ff2ad44bac77d9df62e0e2"
  license "Apache-2.0"
  head "https://github.com/openshift-online/ocm-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0cd9a9705b15f21e4b70ff67b0884a6dace35111e3f8f832601baf0e5a53f67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6228f7a06459ce5cc56ea7bf16ec1adb9c5ef7462c354803c22cb3830e9524f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be7fbecf68effefc102d5a595badf751ba1082a9ba301803c2211d40cef73c57"
    sha256 cellar: :any_skip_relocation, sonoma:        "559594cd07bd97dabb57dfeeb2792d96ae9006ee976a8f6da0a5b8fd74c7455b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48e597602bf5382874756bbedb566c74f4a7e79897a73d77311c3f11dcec4e59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "878b5495ed4e4b31bf1b3de568327841cea73279b3efeee28cb7cb0c823e596a"
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
