class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.14.1/openshift-client-src.tar.gz"
  sha256 "8200c6bf263ecc790594933f194da4ad9c26a57acc4b2f2d2948db7b149bb90a"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "master"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e0f8a88167a5ed46efdb8f2d52f38294b4533889d2390bf4534270023daa396"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "549b440a9a50a2af17affbecc3fc53d6522fae9501c556b704a9c66e25faeb62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5cc13bb39d482a8a7b37e4dcb1aaf2f368b13ff39b0425d8252d5dc1f73e65c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "82e921a8803cee15ab281c650feff622802f9b0d2b52dd40f6bd500794d80fed"
    sha256 cellar: :any_skip_relocation, ventura:        "02bfcaef0235437927b7bb18324e73be0375480fcf8daaa6e647d792fc99d4cc"
    sha256 cellar: :any_skip_relocation, monterey:       "a04fde563668ac004951aff3db0fb7c7da035d81fea5062db741efa305ad0567"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5145ed108cab3507fdbf5e6382a249a3aa94849fb9d97fcf2f550c2f417428d"
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
