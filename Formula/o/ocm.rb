class Ocm < Formula
  desc "CLI for the Red Hat OpenShift Cluster Manager"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift-online/ocm-cli/archive/refs/tags/v1.0.15.tar.gz"
  sha256 "f8fea3b5ef66825646fb3adfeb8dbf0abb76fee3cc1a27f083d37280296bd31f"
  license "Apache-2.0"
  revision 1
  head "https://github.com/openshift-online/ocm-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0db7904125e42eac94a02883c6ba9343f82e0ab279d08360d49b6ab078dbb0e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e189b1188a2646cd5b6de5be3a730e3fa58ea49f8d5ed7f1e8fda3aee6d805ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1a618991da7aba41487605db4fb061e78aa24e8e1e052719456822ae0999cd1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "626097f703a7d4554e964654ff5294a0be82ce48190c8160e15e7c309f7d4db3"
    sha256 cellar: :any,                 x86_64_linux:  "7aef5ba69986799220a9613e965d590c355a5b1b2e48ed31b29aa0542dacb094"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/ocm"
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
