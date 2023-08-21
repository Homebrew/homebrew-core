class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.13.8/openshift-client-src.tar.gz"
  sha256 "95200299f849ce62326fee0ba28770ce6afa5590bdd0c3de6887e9bad0485cfb"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "master"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b552c624004d6a4268406136b25db7e38126c828e414bd78051aff6a5b6492b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1aaaf7c6cd54808b15efc20f443d74192611abe5e42899412b189a3c183ea6a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f930fecc0bd3d83f04f8ad3b830dd7f54245c4e5bdd7ecbda335c7e8e4ceea57"
    sha256 cellar: :any_skip_relocation, ventura:        "56f6f75f6a6779e3f8aa05075e48d41934e465668c917d28781e2a022e6bd89f"
    sha256 cellar: :any_skip_relocation, monterey:       "ccea5bd9358c1d0522bd179562b9a07a2438ecc3db4385f038b23dc28b732099"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d856be77096b6861d3e5f13a9b0bfae980578983b28c5c9dbaa21a4af0d34db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b4a5e2188ae44416f2243e6077c93bb3f6e58222478d9884df1362d74e57529"
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
