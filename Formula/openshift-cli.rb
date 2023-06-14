class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.13.1/openshift-client-src.tar.gz"
  sha256 "c362a296c6e9e92f75cf4f2818a7277cc031426f38da605e5eaf39b3207c8c47"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "master"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16a278a85934020fa9cf65693ee352577a299cd0d335ce71cf71ca08317379b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aae4c97e4404d96638539d8b60a8a05e7e8e5a8132a4b8858cc421d12f3c3183"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c80c99e868c5e91179ce6102068f96696ed26ff5311f919dbe6cee7c993ac7a3"
    sha256 cellar: :any_skip_relocation, ventura:        "0618c5c41674943129b2a14830c639193be8b1a76e0184279fae8d7359b5d33f"
    sha256 cellar: :any_skip_relocation, monterey:       "1f9a5f13b2017269ab38dbacee829cd0b3c67d55884f054a2510ecde853b2bab"
    sha256 cellar: :any_skip_relocation, big_sur:        "758286532516aff8bb979e969f922554c015777bb4ce77c0304d984991983917"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa9552606db3acae23bf8c7ed1c2bab64c727756d14586ed15d66404caf9e0b5"
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
