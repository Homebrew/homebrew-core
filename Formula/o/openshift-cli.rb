class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.18.8/openshift-client-src.tar.gz"
  # This project employs synchronized versioning so the sha256 may not change on version bumps
  sha256 "583abfd280c49a651f9edabb0ea3988ec2bc961c8723a24d6705ec1232c241ba"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "master"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2c5a454b03b811247a775c1c93f81c7dbc10777a499f96c5280c5e60f8e7aa0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "676027fdfc2ae31ed71eb1dba0389d980a9ddc7af9b79753441004aa064047f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c450f3b45602ac45b471eaeefc207559c5fdcda2517a8e7870330e57098f7c18"
    sha256 cellar: :any_skip_relocation, sonoma:        "1165a1148229db24c6ccdeecf4aeddb79f5c07e09c612a2e5d47d08306a083f2"
    sha256 cellar: :any_skip_relocation, ventura:       "800a99e16daa152114eb9a1cda1b4b4a36c5c02f79f1545391262972a34f36e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7ca3c8edd2ec63cfe50b1006aceffc8217f28cecee3944ed7d93a2fc0300db7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b10107be61de292111235ec7ea983442e0d41ecaa646010e4a127842cfca9b1"
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
