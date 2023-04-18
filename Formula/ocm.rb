class Ocm < Formula
  desc "CLI for the Red Hat OpenShift Cluster Manager"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift-online/ocm-cli/archive/refs/tags/v0.1.66.tar.gz"
  sha256 "dc2dd8957d47f981614dc344a17950725c583b488118029440c349b4690ded31"
  license "Apache-2.0"
  head "https://github.com/openshift-online/ocm-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d077450a471463362a0b5d23b094f1552c7ed485b14c5ae06c0f52953179d4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d077450a471463362a0b5d23b094f1552c7ed485b14c5ae06c0f52953179d4e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d077450a471463362a0b5d23b094f1552c7ed485b14c5ae06c0f52953179d4e"
    sha256 cellar: :any_skip_relocation, ventura:        "7d27996e6ef652fe3e7a8a889241c73fbafc6e826b6deccc5bd83f24ec3425a7"
    sha256 cellar: :any_skip_relocation, monterey:       "7d27996e6ef652fe3e7a8a889241c73fbafc6e826b6deccc5bd83f24ec3425a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d27996e6ef652fe3e7a8a889241c73fbafc6e826b6deccc5bd83f24ec3425a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46afb18fb1c48f9cbde05156a7506d528d02adbb36693f224bab815c51172219"
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
