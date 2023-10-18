class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.13.14/openshift-client-src.tar.gz"
  sha256 "6b6ac6109dbbc8240a343d4a07661cf98ae008305bf432b58ca6b9c00c5a83d5"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "master"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a7e8e85a845428ec0182dae12f0e50b110835f29296a7e0673956781cf7d0ad4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ac79f2b45e2353f648f6e49ebabbe11225afdf1cb969cdc1a718cbf5938f192"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a689f589533072a8a01cdca437c0bbd9588691de8ffeb4c9fde30a1fc244920d"
    sha256 cellar: :any_skip_relocation, sonoma:         "e72f0f79dd35b162f2233946e408803aba5cc7fd5d23d67862459f9f36680c21"
    sha256 cellar: :any_skip_relocation, ventura:        "469b727daa30c9e170f1986c87f3d89a7c15e9c884a9245b2cb30d1c70255ae5"
    sha256 cellar: :any_skip_relocation, monterey:       "ca4f174ced85f240787838645dc012801b90284bba8e14606f60e6c620fadb2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "844b117729cc1f4082f6f22e8bd2398bbc42b1aba0f5b530bb590232cfe761ba"
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
