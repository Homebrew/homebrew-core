class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.20.4/openshift-client-src.tar.gz"
  # This project employs synchronized versioning so the sha256 may not change on version bumps
  sha256 "a89ed767de0f014a3aac30c7bd4052e385c9959293caeb75ec660af1344b537c"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "main"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50a6a6ac4c3d532747ed0ce2bb31d87668b8b6df3d230ee841b5ac97d79416ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14b053bd2615453e9f50f8e50ef21b3fce5e96cf80f9f1f2de1b6987303578a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51a4b207ad137307940e3b040c867b193d6dbfe8d335a9848ae99d7b54dfe4a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "a66bb51fd2a83626b9273b45fbd7f5f706d7e24243c151306da48c23a2585e0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27c70ec101040386b5b79f47512602bdff840119e7b4d6ef0b8fbe8444c4539d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1baf10f3bda7bc79c531b8241eb15a9232a48f96058b7af689b1ad10913d9ee9"
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
