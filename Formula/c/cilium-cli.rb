class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.16.15.tar.gz"
  sha256 "2c3da085574d038c5d456425140177d290c36ccb4dcdb2941357b867876aa48a"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f78f2725fb238bacf407442bf0b0671420c8d6b616596f68ca4b936517782d52"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae988301b31ba174453abd6240e22fbf826f38e3e394854478a2528d1e0e219b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca2f003066197c96fc48f07da326bb3c8ae605e22eb18a7399dbbb28dcb817f2"
    sha256 cellar: :any_skip_relocation, sonoma:         "4f12da66841698aead40bf37cfe90bcd7b30fd21788013a46edf015e315413e2"
    sha256 cellar: :any_skip_relocation, ventura:        "89d008337b484ae5a15bc39a64e0dfdc2f90e5af0b04f5dee04d9ad1d0cedf92"
    sha256 cellar: :any_skip_relocation, monterey:       "2cd84bdfdede41fbe556f13aa3f8b2252bd805396f3c7e679dc84529e3fca96e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0fee8faeb7854aef8fc253b0c8e7cd2f31c2c70dbb64a00da3b6348cc250f7d"
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
