class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/5.0.1/openshift-client-src.tar.gz"
  # This project employs synchronized versioning so the sha256 may not change on version bumps
  sha256 "58e63e4aaf8059b7c9edb28570eba1f105ce3c15897d3a4bb4bb7d7c1a3a730e"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "main"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5cd509ffa8a22540c81bc45c909536a5e5db5de5a276a3efcef605ae050f1d45"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7059e4d72d601657ff1e53660699c1f925f7d03b6096dff3fc768edde1fb8288"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2890c7422e3a0958d2a784db648ef76675991b685d2381f1dd3df932166011dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bad43d349ab4afe0266f51c9496e8e5a446e305fd5ec94c63d406aea92a8c8a9"
    sha256 cellar: :any,                 x86_64_linux:      "c13dd993aa0786fed73c0785e95fd06e21f856ba258ed46863fd269b0c8c8caa"
  end

  depends_on "go" => :build
  uses_from_macos "krb5"

  # `test do` block connects to api.openshift.com
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    os = OS.kernel_name.downcase
    revision = build.head? ? Utils.git_head : Pathname.pwd.basename.to_s.delete_prefix("oc-")

    # See https://github.com/Homebrew/brew/issues/14763
    ENV.O0 if OS.linux?

    system "make", "cross-build-#{os}-#{arch}", "OS_GIT_VERSION=#{version}", "SOURCE_GIT_COMMIT=#{revision}", "SHELL=/bin/bash"
    bin.install "_output/bin/#{os}_#{arch}/oc"
    generate_completions_from_executable(bin/"oc", shell_parameter_format: :cobra)
  end

  test do
    # Grab version details from built client
    version_raw = shell_output("#{bin}/oc version --client --output=json")
    version_json = JSON.parse(version_raw)

    # Ensure that we had a clean build tree
    assert_equal "clean", version_json["clientVersion"]["gitTreeState"]

    # Verify the built artifact matches the formula
    assert_match version_json["clientVersion"]["gitVersion"], "v#{version}"

    # Get remote release details
    # TODO: Restore the semantic version lookup once `oc` resolves versions beyond 4.x from the update graph
    # release_raw = shell_output("#{bin}/oc adm release info #{version} --output=json")
    release_image = "quay.io/openshift-release-dev/ocp-release:#{version}-x86_64"
    release_raw = shell_output("#{bin}/oc adm release info #{release_image} --output=json")
    release_json = JSON.parse(release_raw)

    # Verify the formula matches the release data for the version
    assert_match version_json["clientVersion"]["gitCommit"],
      release_json["references"]["spec"]["tags"].find { |tag|
        tag["name"]=="cli"
      } ["annotations"]["io.openshift.build.commit.id"]

    # Test that we can generate and write a kubeconfig
    (testpath/"kubeconfig").write ""
    system "KUBECONFIG=#{testpath}/kubeconfig #{bin}/oc config set-context foo 2>&1"
    assert_match "foo", shell_output("KUBECONFIG=#{testpath}/kubeconfig #{bin}/oc config get-contexts -o name")
  end
end
