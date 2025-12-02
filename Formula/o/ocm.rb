class Ocm < Formula
  desc "CLI for the Red Hat OpenShift Cluster Manager"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift-online/ocm-cli/archive/refs/tags/v1.0.10.tar.gz"
  sha256 "e8dd8a436892f0b75d703f98e4dabe66c6e3e567a6afb4511ef252045ff1229b"
  license "Apache-2.0"
  head "https://github.com/openshift-online/ocm-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8660dea204623d4dc3a35deef9152d7c8fa42f29393cee5b2f24ac720295d1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cb721abba2413237ab1f6e2941c7d4fdbf433d436c8e3365331e324b7ebf806"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9f0468bb67dc7ee9d0e3d5b9e511f290c9ac6e0b1667dc1be0f8b2170690925"
    sha256 cellar: :any_skip_relocation, sonoma:        "f598c4fd738258bc4e62b0b05921cbb422c57d68342210af8a4f5bc8f28cab04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e47d6f0b3a9006159b3d45ba291af1f03fa56a1094208c9d0747f50839fe775c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d2edc154137799b73fe84b13a739c87aabaf76265de9f4b9d5d5837c2380b4e"
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
