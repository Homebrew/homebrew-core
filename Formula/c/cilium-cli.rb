class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.15.11.tar.gz"
  sha256 "4c0021ae152d4ffa107daa30d9828122a8670cfdf95a4a059cc4771dd34e2b2b"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb8f26908540554658e525402a090dee1ee5fa1ee046f93fa780fc802ed0364b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23627380a77124e0865453054437c62a3f7930f78a52aa64e21a639b4616841f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a638e9cb58ee2c972bf9b3d22d488124f9c8ee9ccdc99c44edd43f3abccbbb3"
    sha256 cellar: :any_skip_relocation, sonoma:         "7537b7f191626ca880bf8b54df6783c8f12ec330a79c9e43e21e564969981d49"
    sha256 cellar: :any_skip_relocation, ventura:        "37e9de9319c7071a4a8b510d688d128a8b5c7848e906bac0fe71911b193329b6"
    sha256 cellar: :any_skip_relocation, monterey:       "13ca84551244f82bce4b43371ea91f20177cf407b897c552015cb6b1ad133118"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fd22c73c2adb135e473425684ec421c9ed7f46dff1c670778709a9098ae22f1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/cilium-cli/cli.Version=v#{version}"
    system "go", "build", *std_go_args(output: bin/"cilium", ldflags: ldflags), "./cmd/cilium"

    generate_completions_from_executable(bin/"cilium", "completion", base_name: "cilium")
  end

  test do
    assert_match("cilium-cli: v#{version}", shell_output("#{bin}/cilium version 2>&1"))
    assert_match("Kubernetes cluster unreachable", shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end
