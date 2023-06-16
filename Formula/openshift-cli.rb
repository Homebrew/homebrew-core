class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.13.2/openshift-client-src.tar.gz"
  sha256 "6b61d6a35cddafe1569e687b7ecd8f782c325f19c0b702713b5f9ff7a81881e9"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "master"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ab5d6a3b561163d7aa3c781023c253886563d948f047b6acaabfb4aa22d412f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "243d0fd27d885cade324866401d87a6c7b0422e36dd7aa5c7ec374cdb57d3e11"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eba33022e3e7cd93a270dc6cbfae074a0b51981f402b4c66755bad32bcf22cb5"
    sha256 cellar: :any_skip_relocation, ventura:        "54690ad3bfb1cb2c9aeac767cf5710513cf31da59e08c06ff317f98e62670249"
    sha256 cellar: :any_skip_relocation, monterey:       "508d430a79aca7a2185ba73a1462f7a344028c82a54a75a9cd251b41f63f1231"
    sha256 cellar: :any_skip_relocation, big_sur:        "05a40a6d6b7c449eab6b1695b631154013bd41cb1e2099a6aa60211ebd06227f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c06a0400536b00554661c58037837bb61856dcfee2264bbbd1ed8b0ad3a94c81"
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
