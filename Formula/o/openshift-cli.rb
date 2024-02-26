class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.14.12/openshift-client-src.tar.gz"
  sha256 "a2dcdbc17ef649e3fb52b0e51943bc60adfdb126c46b18a8649f768a40afe00d"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "master"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd8f343e3ece5da314d9a676dbfd0e0502a3c8f58c3d83feccf0ebfbb0e83005"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca6215b971f2f2b3a0814ba686303cefa60d4d3d2ee0ed668a8c89647ef18038"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2adbe9c7c494a03f79e94d7e81d37a7a74f4d8c71792485a33876fac7fddbef"
    sha256 cellar: :any_skip_relocation, sonoma:         "65dc80514be067ebf160903dd7209b99bb1d2df0ef9d3c3b754648babd895824"
    sha256 cellar: :any_skip_relocation, ventura:        "0592cf59881a32873397c1aac77ee8c36cd51fc7449254e1e5007a0dbac39548"
    sha256 cellar: :any_skip_relocation, monterey:       "92a4e2aba911039e4d761d5ecf1c6cf1db9e214bf310cb5e4854d3ec4e4201d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63cd5bf96dce3c172a70a973dc6472ce1606fd02b6154d38d216e7cdce916a8a"
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
