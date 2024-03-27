class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.15.3/openshift-client-src.tar.gz"
  sha256 "8999d3c360508e5dfdb741f21ec932258fef8d834e79130cea71c1b6839c46c9"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "master"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b524d504365977ccd74024aeb0f5b699aa0564e5b04a59b61235fe4f2777ad9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2825e8ac74a78b49854a2d0518787c16131c5e090f51a3b1bed2dd5a8bac360"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd2faffaecd5c477197e5fcb1ab4ec5d4b0ef8a9f5c1becd29cc1f8b41d043c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "43c978515ebae87adf4b5e93c62ce2eb17da264c78c4657f558922c4a8dc2618"
    sha256 cellar: :any_skip_relocation, ventura:        "111fcf8be0a6f40c86e1c8d97e572253e0a47cca5687586aecb604e25701713e"
    sha256 cellar: :any_skip_relocation, monterey:       "1f3e2c075af2e677ecddab3c224e3746a34874b5fb10245f78b28a64577cce96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2389ccc2b3e7e7ed9e8942249c52a243dc3b8d76b42a2d49289df6b5c1662d4"
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
