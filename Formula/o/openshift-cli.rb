class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.19.2/openshift-client-src.tar.gz"
  # This project employs synchronized versioning so the sha256 may not change on version bumps
  sha256 "a0626502ac41fa0d76e37990253b5b6c515847b272e496ca288ac360bace6581"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "master"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93bb3c752b0c570fd27d58c6ece998fe3bb3b02c5a000cf0b1e7e356116f9a2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e03fb108a59d95bbb31bc7131d7d4623ed9a4a229ff7abd705b86a43653f72ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c720c2a8a8ee1104ff40111a2a50d4bc22ddfab225a4ee4779c9e2676281a19a"
    sha256 cellar: :any_skip_relocation, sonoma:        "fdfa4ac570b22aad02588e2a68b558e9efe22d9dd8532a034d5992884dd5c950"
    sha256 cellar: :any_skip_relocation, ventura:       "a556673dd9f121a63537bd5d959787a525d894ed8870e9341cfa960e627fac1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "202ca2e30ac3a5f1e83ae686501a9dda4aa7fca7d7c41f1c336b99b10b3ca9fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1689e1295eb6d3277845e497a2dd87989ead34f7961934c34ffea5f766649504"
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
