class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.15.15/openshift-client-src.tar.gz"
  sha256 "a7ecc96a0f70020d0b02a7c408cf11b30e63bc6a4cd37dae747f5675532ffa08"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "master"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "02d23562c1e6a3619c63fd8a353df2decfefb5fcf0e35af32eea11ade6616361"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fedeca22cff2189340430f996e0bb161ffa2b1b8a072ff0adbdd8dcf055353ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17b2f4aa4d61b0fefca84dc2e0ad2aaf5269c46b1e9bab664234fc46cecdf1ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "a8495b33dcb997c9485747f4917e3a5903b4c6fc771e236d9224c99d55e2d28d"
    sha256 cellar: :any_skip_relocation, ventura:        "e73901c547f44060afbc1ca8dcff20aaa3983fd0d1284cd82f4621a5ddb1a415"
    sha256 cellar: :any_skip_relocation, monterey:       "04d9bc5d6bb4c9b66437e7e914febd596cffaca87b71cea2d92d56d8e6dd7491"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b57ccc6328aa0922ecb898e0b1fe9d224d66f97ddc96b170f0c3ddb29946711"
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
