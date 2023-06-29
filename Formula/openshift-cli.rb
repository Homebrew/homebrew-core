class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.13.3/openshift-client-src.tar.gz"
  sha256 "3a1431859b3261f8a53dcf3be861520dc19d61c93bcea482bff5364d4f594211"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "master"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51d581ad832e1d115896fb9ca1e026e8adbcafbe446930de0d2a5f1befdadc4b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b6c06659ae94c146e6299bad5d64b0809fda26620c4f7edfa290c7438465877"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e77a4a82e374134419e73ee7d0e14241cdec0438c156151edd4e173a8d17a961"
    sha256 cellar: :any_skip_relocation, ventura:        "5ec61c9cedb614d23ad3c2425e78aa57b036cf004780cd51a4f1c353c4937b04"
    sha256 cellar: :any_skip_relocation, monterey:       "71f000160467d5455bb2008f015b89eb12779f6eb0ae19d1efffba4d01a64308"
    sha256 cellar: :any_skip_relocation, big_sur:        "7994d373c8d06df7b740f8dbe3853281e0a28af9f95facd6ef1cdaa586833a43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41c6a63976a76ba145f8b19d2189a7e151e3c9c39db457c4770ecf356c6a2e34"
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
