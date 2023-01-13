class Ocm < Formula
  desc "CLI for the Red Hat OpenShift Cluster Manager"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift-online/ocm-cli/archive/refs/tags/v0.1.65.tar.gz"
  sha256 "599e03907783cf468d2652ab91b7e6ee31385797269a6d23c68ad3dbacc404f3"
  license "Apache-2.0"
  head "https://github.com/openshift-online/ocm-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aead939b61e7c37e3f89271e6a1405976fdc74d466b462190808f509851c5e21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfc2c992f84c0cf022be8156514f1e1b81378f6a0ed2e9bbd9e85b0bf3b58977"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae7a56058e287ef377c2d83b8a9afbf44839e0e695772a274b9f773d743fad4a"
    sha256 cellar: :any_skip_relocation, ventura:        "801e7921bfaf9357aa02b76c0d228e9cf25e96be716a60c227011d6c066676d3"
    sha256 cellar: :any_skip_relocation, monterey:       "c67adac6ca5f5315868c15493592ea4dde34ca87e18679b4c44e8e5136b29de8"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e6443531e87492710c5158bf00a530d32ce25b479378ccd9d79523971bca698"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71dffd85ebc0f49884345ad4c1be511b0f8948edafb663dbfd2b15671309ec5f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/ocm"
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
