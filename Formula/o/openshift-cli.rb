class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.13.9/openshift-client-src.tar.gz"
  sha256 "95200299f849ce62326fee0ba28770ce6afa5590bdd0c3de6887e9bad0485cfb"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "master"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed6682cbfe9dd594434cd2dcdc4cf7c0184276f4f990dd2a96f9882861a8a6b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "082551aab7781ac323ddfec639d0b929dbcf98791f2c6d31c52049caeec12821"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "669f7a95ab8187524cdab0b61af4ce471a2fb672445c3f53800e1b5bf3bac074"
    sha256 cellar: :any_skip_relocation, ventura:        "c8b8c81ff2f956e98bf520d0d5fbb6dd2ac4e3024f83d589b7ecdcc470226c97"
    sha256 cellar: :any_skip_relocation, monterey:       "1255c4d1c8b6a3cc8d2ce983e162dcedec827a6da398593abd6a2cb8e04ffd3f"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f3d75092266a4477bfeb9e08d0195988317be99155e411045ab00b681ba0dda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e866af9e29c7c4568881084ac5d8b638bf85446357512bcd4582d64fea5ffa4"
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
