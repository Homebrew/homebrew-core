class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.20.3/openshift-client-src.tar.gz"
  # This project employs synchronized versioning so the sha256 may not change on version bumps
  sha256 "e5cfb94ed2d4c819287ab703963f53b7cfc5bc59c92ef6728590e47ebcd2cb20"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "main"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "299f43855ab0ed77fac57b9b583ebfa7829dbd8a255f7f227cf164c9614f45eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "723ae0d82d411e6734cf7e9d159cc518e22c9f436d4adcf7a007ee6a0d6991ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a15d86e46a0af41a7dae3774cf75eee50dbe903f1307ead9075099749b7566b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5aa16d1cf1e5bc3b2ccba5b60b87f62f2a6914dcd5e1f40b22ef17c111fc33c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e00d04e16b2bb20ae04185c63c528785e0d970fdec953647664ae5d39abcc6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b1f61dfda438898da73b5494d8fe7956c2af3b7b4a4ead129194483ab0eb977"
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
    generate_completions_from_executable(bin/"oc", "completion")
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
    release_raw = shell_output("#{bin}/oc adm release info #{version} --output=json")
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
