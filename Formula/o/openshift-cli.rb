class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.21.5/openshift-client-src.tar.gz"
  # This project employs synchronized versioning so the sha256 may not change on version bumps
  sha256 "060ac7cb56266f27268a5ec304720f1d8d9d9230c1070159b2a836e9cf70183e"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "main"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a507926e0d5a11b99a0875762e40b91381d1c95dd7354838bc9a1bd0044f55e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9139691ef92a8015d4bed5de3be2dd331c48cb5c27f8a41bd06036c30ac1c255"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4197ddfab4ca272b954c02bfa1ba6ec870be7df5fd0d51419642e33da0f8b739"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e78aff7bf7625cba9939db6299a2a3edc6b1b583ec86b92b8961bb5f44129cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5186e967be3cbf442318e6258b3270bdd9a1cbbdb2ed80d52bb1723db32f7be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c0509b8ecc999edc5a729dcaec99857485aa1cf206d09ac802f0ffe852b10c0"
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
    generate_completions_from_executable(bin/"oc", shell_parameter_format: :cobra)
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
