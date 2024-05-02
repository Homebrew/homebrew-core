class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.15.9/openshift-client-src.tar.gz"
  sha256 "485619d379e41e6d0ae65c1b0c7f90d3764730e0a87e5685da761d76106d25c4"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "master"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "274e26638727bdf7bcc0ef6d13e20eaf9a0212f2f8db3d360aa158e89f2bb27a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50dfbafe319b6949badf84b2cb835d0fbe91af5533e2839e865aecbe7ac5ef17"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d1e6b117f37228cc968ad45aecab91366e7396458f2f23559fd2f6a1c98790a"
    sha256 cellar: :any_skip_relocation, sonoma:         "a056fc20c686c99f7a072df35b1c5b1d961a1506401193147ff0e8ecab5f886c"
    sha256 cellar: :any_skip_relocation, ventura:        "97b4ae4cf305a4e39856c2f323b624337aee7fa7325bc6a40214498efaa22272"
    sha256 cellar: :any_skip_relocation, monterey:       "551cb27d0facdb049297965aba8536f7403c8e7e71768ecfbfb38e0862c29572"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03977efc787b40e81f3a1c55c623489a172fff7a03d2eccfe3b27e4463889570"
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
