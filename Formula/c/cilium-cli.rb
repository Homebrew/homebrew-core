class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.16.3.tar.gz"
  sha256 "8f6a5709abe6c30fbbc7a7d573f0fbaf44fdebf3142b7085910d2a71e9878e15"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3d6a643b9f753737029d2161966fea7940072ee1e039378ab51b701edfa0b75c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7920c33245e9f3cd76f95a9853d9706797b6176921e40902b3e92c33e3cf3c3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8135fbe3ec7c3c88abc53c204d5f9ef26ae4660f038079417f5d4ed3d5d2b4e"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb4f7650fa48ba5bea220f05ac6d03d9d9f1d0c66c9f5816416ad4f6ae53547c"
    sha256 cellar: :any_skip_relocation, ventura:        "76689de9d64e1140db6ad124ae7b8c34239faec030c7b96ff3b03b2d0ae5ed1c"
    sha256 cellar: :any_skip_relocation, monterey:       "83e80dc641a9684cb5853598ccd960856f2de932a95bcfd12e08d317b2efb1ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f79092a0a1f088a891a2d6db367ca3504afb438bb5c07841f152a722dc68612c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/cilium-cli/defaults.CLIVersion=v#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"cilium"), "./cmd/cilium"

    generate_completions_from_executable(bin/"cilium", "completion", base_name: "cilium")
  end

  test do
    assert_match("cilium-cli: v#{version}", shell_output("#{bin}/cilium version 2>&1"))
    assert_match("Kubernetes cluster unreachable", shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end
