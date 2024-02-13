class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.14.10/openshift-client-src.tar.gz"
  sha256 "a2dcdbc17ef649e3fb52b0e51943bc60adfdb126c46b18a8649f768a40afe00d"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "master"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8730e86aa07e4a1037a7e3e53a7b7fed337409ef7dd6111a30e7cf3ec8770d88"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a07cf72dc45f5a2e913b383f21bf0b7ca53efaf1801f776b9805b128f039b1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f59134929a7e9dd966d4d207c48ca14c3e53de732a740f486a988f1111979a5"
    sha256 cellar: :any_skip_relocation, sonoma:         "f63c57d0f695ebd4f0ea903add78c8e0ac4eb17e1c100194c5165bfa069cedef"
    sha256 cellar: :any_skip_relocation, ventura:        "189d9f7d4c720fc4d81ba55b18087056565b368f46bb3e8746967efb1b112aa8"
    sha256 cellar: :any_skip_relocation, monterey:       "6bdf41bd1a3557f11d017929282a8d6cf57c0455bf57bd423d7a4d3cfe4d82e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b5b0f95545ac2173f21c83842535e53950ef6399e6d2a4e3747a4218f8fad0d"
  end

  depends_on "go" => :build
  uses_from_macos "krb5"

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    os = OS.kernel_name.downcase
    revision = build.head? ? Utils.git_head : Pathname.pwd.basename.to_s.delete_prefix("oc-")

    # See https://github.com/Homebrew/brew/issues/14763
    ENV.O0 if OS.linux?

    system "make", "cross-build-#{os}-#{arch}", "OS_GIT_VERSION=#{version}", "SOURCE_GIT_COMMIT=#{revision}", "SHELL=/bin/bash"
    bin.install "_output/bin/#{os}_#{arch}/oc"
    generate_completions_from_executable(bin/"oc", "completion", base_name: "oc")
  end

  test do
    # Grab version details from built client
    version_raw = shell_output("#{bin}/oc version --client --output=json")
    version_json = JSON.parse(version_raw)

    # Ensure that we had a clean build tree
    assert_equal "clean", version_json["clientVersion"]["gitTreeState"]

    if stable?
      # Verify the built artifact matches the formula
      assert_match version_json["clientVersion"]["gitVersion"], "v#{version}"

      # Get remote release details
      release_raw = shell_output("#{bin}/oc adm release info #{version} --output=json")
      release_json = JSON.parse(release_raw)

      # Verify the formula matches the release data for the version
      assert_match version_json["clientVersion"]["gitCommit"],
        release_json["references"]["spec"]["tags"].find { |tag|
          tag["name"]=="cli"
        } ["annotations"]["io.openshift.build.commit.id"]

    end

    # Test that we can generate and write a kubeconfig
    (testpath/"kubeconfig").write ""
    system "KUBECONFIG=#{testpath}/kubeconfig #{bin}/oc config set-context foo 2>&1"
    assert_match "foo", shell_output("KUBECONFIG=#{testpath}/kubeconfig #{bin}/oc config get-contexts -o name")
  end
end
