class Ocm < Formula
  desc "CLI for the Red Hat OpenShift Cluster Manager"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift-online/ocm-cli/archive/refs/tags/v1.0.6.tar.gz"
  sha256 "2773eb36c66cea85f4fb6aa5f0ffbf323046dae2b1ed5a37f18b487022f6414b"
  license "Apache-2.0"
  head "https://github.com/openshift-online/ocm-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3095b2b95242640613530c462d6eeab9e5574d9cc838995bba0d4b42d183b34c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ec56731ab7024207464e6a180e380d9b02b7b2e50ffa34f4504e2ba29c7fe6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed72e2dea0d681b905159ced9227122648d597a02cfcf25b5185e4c47870ec2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "06ca1f20cf34632c6f61a2f87719cae73e984563c29e83e4ead7745b5eeac2e9"
    sha256 cellar: :any_skip_relocation, ventura:       "36e21a01b915a01f651f8d6057c9eef1ce9709c9d5295acad045147fcc830fd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ebcc5ad5cd2d78f5494ba9550bfd1f2e2236b631ff01f1e4a92d0ad052b577f"
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
