class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.28.2",
      revision: "89a4ea3e1e4ddd7f7572286090359983e0387b2f"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1c9fc80e17d7f48d3f736075e803356d2a3382e3791739f2f53f931d61b92e10"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "008efb3291080289cb4bfa502f8ca86f5647d6e4cc10435f2a18853eec129f2d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19f901ad385a5dcc2e6099b15c03b3b4027bcac1e7134f7c96460fbf25c61a2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85697cec14c761bb43f8bc43836e380b8331f2cfd0f840fbf3a53828299d2721"
    sha256 cellar: :any_skip_relocation, sonoma:         "7db1b0d71f8c4ce57cdcebe8b45d2cb1ec4e54045d48f9eb503be70ff7f8d983"
    sha256 cellar: :any_skip_relocation, ventura:        "743545b7552420f17f7d5f43304cbaab879afa942daab4f5ba1b980585ef2ff2"
    sha256 cellar: :any_skip_relocation, monterey:       "ccbab15d59b2540033ec7ce42c1ccc157562f1d70de714b17cda7301fba7f23c"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd3ef297eca0e361b74fdd5a4b0b6e19f8cdf0f6df21e80ac82f9a2aa3194b82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ed660386217db4f4b9e3c006d2c36da39068d787630b5a5f32b7e1140036f7b"
  end

  depends_on "bash" => :build
  depends_on "coreutils" => :build
  depends_on "go" => :build

  uses_from_macos "rsync" => :build

  def install
    # Don't dirty the git tree
    rm_rf ".brew_home"

    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin" # needs GNU date
    system "make", "WHAT=cmd/kubectl"
    bin.install "_output/bin/kubectl"

    generate_completions_from_executable(bin/"kubectl", "completion", base_name: "kubectl")

    # Install man pages
    # Leave this step for the end as this dirties the git tree
    system "hack/update-generated-docs.sh"
    man1.install Dir["docs/man/man1/*.1"]
  end

  test do
    run_output = shell_output("#{bin}/kubectl 2>&1")
    assert_match "kubectl controls the Kubernetes cluster manager.", run_output

    version_output = shell_output("#{bin}/kubectl version --client --output=yaml 2>&1")
    assert_match "gitTreeState: clean", version_output
    if build.stable?
      revision = stable.specs[:revision]
      assert_match revision.to_s, version_output
    end
  end
end
