class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.16.7.tar.gz"
  sha256 "3f4af0d0f30c5ebd379c5d33244d9fb155d71f618d76332bd8d8cb6bd08e29e0"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8897ef54a78a42ab89ec7c2d75a94f10da127c802cbcc60c6d141a18a0a2aa90"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a499fe33d3c0a010e3953167538c77352cccb41a9db64f7557c559dd6c627ff4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07ce8a6ac52d5c9e3f16ed5e499401a5e84f09cc71e6ed3e13415b9157d5fb3a"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd045b6305378affca9ef32b7c196b6b841c8b983d78ac1c68341a78d7fb65bf"
    sha256 cellar: :any_skip_relocation, ventura:        "df207a5b88c7d1940997c9e076509b597fa02800fa09679538c49487e1f478e8"
    sha256 cellar: :any_skip_relocation, monterey:       "e25f196c075e0f9b7856aaf6adf7124a6b76c12a7125ffdaee7e232c2c2ca800"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8b8b4bbb900fe2a1d37e4dee34dad1233b00cb14ef1fe5ca54462b1badb1345"
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
