class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.13.12/openshift-client-src.tar.gz"
  sha256 "6b6ac6109dbbc8240a343d4a07661cf98ae008305bf432b58ca6b9c00c5a83d5"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "master"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "00389f31e8b9408551108c7eb708377414d4dc01d14e37b842dab2ab0d8132fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd3c3671fa2398d983d72dea13490669ab38b299cf13e56c93b40605afa53845"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5de2e80923a10170f3dd0a5212208595cc2048920715fa548f91846617fed043"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75f98a4583b0d46690579029092539e22913c2c21fa3be3c866e85a8b6849f55"
    sha256 cellar: :any_skip_relocation, sonoma:         "511d9c42f3c3297b098c3531cfb7c6849c2040bdfeee5baaa622cf2bcdf5678d"
    sha256 cellar: :any_skip_relocation, ventura:        "a91608a88d959e59ce0c65429e0edadee01a967d15e143e79c98e3a9c50fad15"
    sha256 cellar: :any_skip_relocation, monterey:       "b921af3f87183a205728e903c6dc64e1be19cadbf2e6c7e97f6ec04b76abc2a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7ba70ae074292be68a6a6912d62a7f84bd99e45a813fa9313b28c838eb462c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfc811324c77ba0cbeed58f030fc7bb953a04a571c614a32a910704555400521"
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
