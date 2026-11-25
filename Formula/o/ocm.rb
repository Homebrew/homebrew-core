class Ocm < Formula
  desc "CLI for the Red Hat OpenShift Cluster Manager"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift-online/ocm-cli/archive/refs/tags/v1.0.18.tar.gz"
  sha256 "c4938dfe4680a1b065209df0202860a21d7d41df301978abe9ddd388db7d8a0b"
  license "Apache-2.0"
  head "https://github.com/openshift-online/ocm-cli.git", branch: "main"

  bottle do
    manifest_sha256 "c7e11cd435df48ee9dd4e1a95e6bd0999b51a66abf240e76726ce7d8eb9a553a"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d1774fed847610f5d23a86ac9150e5e7c8fe6aa015ae70841a0683da91edf3a3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a2c0a448ea796f694620712a1695dca533bb2e2b015d9795052304451928ec62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6255a550d8397694a2763bb31f8a0be6de82d53bc2134150fc5183a9e7341b8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f06e1a5fff43e86d7c128d6d7b58841c5ced9e3bec975b6c962cccb967585649"
    sha256 cellar: :any,                 x86_64_linux:      "3fe6aa4a3e15293e45112be6877e0282db0c829d84b3bf94b6b33fb85f9155d2"
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
