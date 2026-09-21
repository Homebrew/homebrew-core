class Ocm < Formula
  desc "CLI for the Red Hat OpenShift Cluster Manager"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift-online/ocm-cli/archive/refs/tags/v1.0.17.tar.gz"
  sha256 "32a1cdb04cf69e8a221448866ecd3a3c853059cbac718ac66e85c9cff9d04305"
  license "Apache-2.0"
  head "https://github.com/openshift-online/ocm-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "41c3b10fb6297a89d126c572e4c7ce10572ca4fc476b9e748c2a2b79914e04e2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "82c082b66387172a3f0027fc55b5a8e9ed14ad47d59e6a9b04e5aef340722794"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9007e1d309a1d5dd1b03802dbe6a74dd2bcae559d4ea8b521ab35d52d61e635d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ff4bb846d95928f2411bef6cf479d000cef1608319ff01cec6570cc6e7575c58"
    sha256 cellar: :any,                 x86_64_linux:      "1d10b043639e3c47fe566c268c79f67ddfcd734d0d7847bd7c1245e0b7e30884"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
