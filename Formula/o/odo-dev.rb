class OdoDev < Formula
  desc "Developer-focused CLI for Kubernetes and OpenShift"
  homepage "https://odo.dev"
  url "https://github.com/redhat-developer/odo.git",
      tag:      "v3.15.0",
      revision: "10b5e8a8f5011703a8cb62b4001eead5ae58cf45"
  license "Apache-2.0"
  head "https://github.com/redhat-developer/odo.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c672d0069308c1021b684553cff3478d6a335240b90918a0821618739321a709"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "525b18a5939bfecc93f7a12d377c1f0f1af1b212ed730f206320a2df119e87b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce5cd354eb624a92e8190aa6ca61e9d24c91138e7e6ae6e9220f2790a032d689"
    sha256 cellar: :any_skip_relocation, sonoma:         "a48ad8fde2769145ad4d4c60304efb7796aa66dba65a13c7f750e8717c2cc995"
    sha256 cellar: :any_skip_relocation, ventura:        "964c60a044e232330130dc4b9f793f571dde674d6d38c96b08b9af97f63e490f"
    sha256 cellar: :any_skip_relocation, monterey:       "164c403bacadbed169f696d62c4273737ae01ec6f42410dc57e83b9720bb68f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fee6ebc1a8c640152fe665029fac051c07c554d8221d766c006510815a34bebd"
  end

  depends_on "go" => :build
  conflicts_with "odo", because: "odo also ships 'odo' binary"

  def install
    # Replace `-dirty` suffix in `--version` output with `-Homebrew`.
    inreplace "Makefile", "--dirty", "--dirty=-Homebrew"

    system "make", "bin"
    bin.install "odo"
  end

  test do
    # try set preference
    ENV["GLOBALODOCONFIG"] = "#{testpath}/preference.yaml"
    system bin/"odo", "preference", "set", "ConsentTelemetry", "false"
    system bin/"odo", "preference", "add", "registry", "StagingRegistry", "https://registry.stage.devfile.io"
    assert_predicate testpath/"preference.yaml", :exist?

    # test version
    version_output = shell_output("#{bin}/odo version --client 2>&1").strip
    assert_match(/odo v#{version} \([a-f0-9]{9}-Homebrew\)/, version_output)

    # try to create a new component
    system bin/"odo", "init", "--devfile", "nodejs", "--name", "test", "--devfile-registry", "StagingRegistry"
    assert_predicate testpath/"devfile.yaml", :exist?

    dev_output = shell_output("#{bin}/odo dev 2>&1", 1).strip
    assert_match "✗  unable to access the cluster", dev_output
  end
end
