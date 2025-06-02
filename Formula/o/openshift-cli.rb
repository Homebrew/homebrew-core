class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.18.14/openshift-client-src.tar.gz"
  # This project employs synchronized versioning so the sha256 may not change on version bumps
  sha256 "fcbf4750ecb1131f61b9efd20f82fb5df3b4ff965d8ae68acb2a9b0c4ff380c7"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "master"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10a5fa3f8273a79439a852ad59918cee854c86ce6c77821d2d5d807e6eae95b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bab8707937c976db8ce6a1f915f9cb44ffc081feca3e30e6ad0c610bccea6a99"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "30243fd685419c1024d658f612a976b4c454f1460839913e1399298ccc0b0488"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b4bb4bbcee0a74ef75787a05f0d1c4f149745830c04dc45975c63a26b2a6145"
    sha256 cellar: :any_skip_relocation, ventura:       "a1df8310a39536034547ac12da60416f209dddfce67a6c2fead9a45866a8a34f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2af76eb8a74bf86fb9ab6a8ee98376ef1e605c730e215e1c23423934354f5732"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12b0f7f7d25210d31dc7a0bfcba125c99ae4d1d8a158d99d9dd7807cacaa4475"
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
    generate_completions_from_executable(bin/"oc", "completion")
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
