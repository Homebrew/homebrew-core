class Ocm < Formula
  desc "CLI for the Red Hat OpenShift Cluster Manager"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift-online/ocm-cli/archive/refs/tags/v1.0.8.tar.gz"
  sha256 "8d64e903af844b135f761f8a61845b52bd76c066be7143d542e3f4e2ad4a622d"
  license "Apache-2.0"
  head "https://github.com/openshift-online/ocm-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d79bb7ede63fdb0029beffa8972e831444c7309c49b6af52dd8f135a388758e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e6bbd1864db82c6be92b6afd3615e65157afbaffe5b632748e4c7bd455f1064"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "389e8ca5aafc7516e3f1908428a85d87f2e532913ffacb32b7d5746d0bf81b65"
    sha256 cellar: :any_skip_relocation, sonoma:        "c482f421b767271aef663fd3a887952b916876b6652ad846679f5606d0c637b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8194906c62300381a95386bfae83b631bde7cadb8c0575bf08f1769a4f7c70a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:), "./cmd/ocm"
    generate_completions_from_executable(bin/"ocm", "completion")
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
