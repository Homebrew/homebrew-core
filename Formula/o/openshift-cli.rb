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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "90a11e40100ffc7d63ac0fc008b6d2877d406cac7446ba4c9c4ea746b6b7baa9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2c992fc2a2332207d18549e74e04e1a37281d13a84fada3a21929ba30f136c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a94091537d7fc9f2a01ecf218adc09c6c85321790ac2cded9b9d8943089691f5"
    sha256 cellar: :any_skip_relocation, sonoma:         "17772100c56eaa7f2a41c98127854a80543e04bf333a8702c44423c5fb3fcc9f"
    sha256 cellar: :any_skip_relocation, ventura:        "37a587c81995c984bb3c31c5c4b7de9e6ba8d02b7731b414df9895e8b680b8a6"
    sha256 cellar: :any_skip_relocation, monterey:       "83afc5f762349a029eaeccccc579023198579a59b747c3d721b99661d73b4995"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc371cb26be276e8761c27baced00f6f686446d42036e85b4b1373c15a92ba11"
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
