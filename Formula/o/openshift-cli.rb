class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.15.8/openshift-client-src.tar.gz"
  sha256 "485619d379e41e6d0ae65c1b0c7f90d3764730e0a87e5685da761d76106d25c4"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "master"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0b51931d70db711f3e365e06acc0d81a1a2d49ec18dfb646b65d35122be7cf91"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8f9cc4fe73dfa46264b9a1c2dbd790d3a904d46ec856b12544b5d78f826bc74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "960eef7f35aa20978b522bad1dcca9547eb5da88862f79dc50abe779fc225f93"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb9b5e8b07c205f318551a06ea480915fdd4de4457e78a785e56cb9273e03efc"
    sha256 cellar: :any_skip_relocation, ventura:        "e626a65d37b201d19d2a55780f6c02e865b5640a615f32490b835dd7b5bf4e3f"
    sha256 cellar: :any_skip_relocation, monterey:       "f821c75e30f134a941fd45e8612a498dd4391c7d4b84cf72a98561d2345ef7cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7f89084594a36ae691537350b17a7d936901fa7c6443e32b43cfd2969996377"
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
