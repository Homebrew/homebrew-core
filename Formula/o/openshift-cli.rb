class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.16.6/openshift-client-src.tar.gz"
  sha256 "c0a3da890c60359c9666505cca29c17470800bb0fc6faf02de106de7dc4ca657"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "master"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d06047861b27e6dc4f6e25a53b8bd90bd2e61b13ad6887fb30bbf5f0b6f3f98d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cfc92bde189e71a5291e44e5025556d4d5f3e17d221aa43f353b453ad6648404"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d34cb843dfaffd866c16b848758707fa7ac8b46977df4bd5a6fddcd151b6dee5"
    sha256 cellar: :any_skip_relocation, sonoma:         "e79fd458b9f4da09906c8d29fe3c7de64cabe2fea7df5c21d399025f0c6d48ad"
    sha256 cellar: :any_skip_relocation, ventura:        "540e204b6f640abb9d06bd235ba12c9d9ea254bfa50255200f96d803b4cb866d"
    sha256 cellar: :any_skip_relocation, monterey:       "628bff85e772a393f61f9bd42d8a7461ade84c66e44835cf0dcaa662e3933848"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d25946e163c2df74535b54acaa1393cbefd86e181e6a43e2ca41c83eb94d0ce"
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
