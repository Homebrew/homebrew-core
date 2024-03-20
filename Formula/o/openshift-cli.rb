class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.15.2/openshift-client-src.tar.gz"
  sha256 "8999d3c360508e5dfdb741f21ec932258fef8d834e79130cea71c1b6839c46c9"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "master"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fb2a1ed3eac245361a3ee5a58062c507f161b31a4e909e9f72416c382e42abc6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9573fb7ebe712468f3e59794ea4240fac694d897df9413c81bf828ebc9dc152c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "105c1aa19fdaa0ad98bc5ee35a85631e28e44bcbfd796a962eae8d834f11bba4"
    sha256 cellar: :any_skip_relocation, sonoma:         "0209cdc3b6a1789db52a9c21108c5260d4e65c86052d00da3e7c578688a9908a"
    sha256 cellar: :any_skip_relocation, ventura:        "3f7edc324e794c5c228bb3a7e75c01fcaa6c3b603fd851380735af87a5145cf5"
    sha256 cellar: :any_skip_relocation, monterey:       "d6abddcf9e2ac4f65c497ddeac1ae9e830029a9e969ae86eb870211dc61bf9ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d927f32931d3d77e2a38e8302856761126fdfa848d0baa6f68db9d5bbfd062c"
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
