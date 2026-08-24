class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.22.9/openshift-client-src.tar.gz"
  # This project employs synchronized versioning so the sha256 may not change on version bumps
  sha256 "38e70ffd03ad17aff9202426e1f87e6da7964ed7b1134a6ee9c6ec1fc377221f"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "main"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23f08dc471e1a1ef16ff500db2c3a86f39f392ca65be0f552e3086295117ae8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f100666895a40dff95e6cc20995553ed770573be0888e5c0b06b991d24c0d5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd4dbb6904f5aa8552c86db27bba4a0dc532f6fe804ea1aedecac55e6c1a0d3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d875fb75333e50668512f69c8f871093ced7a216916f45abec4f2dfb67ab7d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d2782f771607dd63715dd35acd9163d89dbd2b21131e9ae3b8a8b336e2f7812"
    sha256 cellar: :any,                 x86_64_linux:  "e4113dda9acfccbeeee90b46b96991cd9001446eedf181f53eb2912460434194"
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
