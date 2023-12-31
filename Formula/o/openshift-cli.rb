class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.14.5/openshift-client-src.tar.gz"
  sha256 "495c9dfd054b377f5ffa7d3a2add613a397f7ffafaf109f8a5b0dcea4392d550"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "master"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5bc17d1f5e4a1dc99843288150c5079b7e5f146b564c29892405b243be2e4bf7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f026efd37cc18c689a3a26a43df7dab9fab37f5d4050bd038a762e40ecf80c5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15235c9baa961f52113d21df05203d8e153e15b302f9093dcf4bbf61c8dd3f91"
    sha256 cellar: :any_skip_relocation, sonoma:         "3173cf3ad5ed480b0eb98203262ac7499514ac50ade4a4ff55bcf1c1f641ea38"
    sha256 cellar: :any_skip_relocation, ventura:        "91dc281975f1b40a0bd369590cfc662c53b6d724ac49e8e7d0d541f773353f76"
    sha256 cellar: :any_skip_relocation, monterey:       "6b27b0de98f754787c509ab0f19092dde9039e156fb537c96c949020ad097d92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f59fc219d4b47fbf1c43f2a63bf46f10eb1534a0510482364e9167a2cc625bd"
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
