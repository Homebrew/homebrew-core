class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.15.16/openshift-client-src.tar.gz"
  sha256 "a7ecc96a0f70020d0b02a7c408cf11b30e63bc6a4cd37dae747f5675532ffa08"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "master"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0c855e38216ec348a21d89aa8c26295b4807779836345af470de54e3e6ec52fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d47f56d43ea545b24faa51dc94d4f36125c8572a06f0a7fdebbb2a1fefe42e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f691cf2c703494aa89c3372364e9672ad573b9fa249eb71b68af547490b693d"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e0f36fb59e2215179b479d00f06fc0d1413af01f3b5e98ababf1997751dbc49"
    sha256 cellar: :any_skip_relocation, ventura:        "4c39696febc578aefc3ab3a007db228c26dc46b04e3979a2855b49114c272179"
    sha256 cellar: :any_skip_relocation, monterey:       "6ceb0a6c9000494ea91d7c27371ab6a6d928c506499b2b7872e55bd57d3f5ef1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "049059dae6381408086560512cd603ae6403c2fa43d5f2ef2684bf85a7f01a27"
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
