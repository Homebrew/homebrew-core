class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.18.2.tar.gz"
  sha256 "d5ad24a477354396c4765c9b76d3e85ee53a63ff9fecd58bf144f624d16e2a56"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2ee0cafc4ece55e1ae2c160786f10617c3a3ef024666a8f1e4abe8684e8e69a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9c13186b242a0db748584483717463a08c73f143125c2b1856ac4770e1f9406"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d4a572ce5574caa605eabd46fc3d12b3973ce4b41854c2825126193bce741e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "76a1bae7a9df4b89cdf806f415418efb8ff17800bdb65f5086e57000f32af5ac"
    sha256 cellar: :any_skip_relocation, ventura:       "b86c1b9bcd84bb7cbbd25a95324d751e9fb302d4d81b03a7b8176614a5dac3b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2838a3ce1b923b9036bacbefb09189b77f37979409eb3d6b51ce988bb3f0cb5"
  end

  depends_on "go" => :build

  def install
    cilium_version_url = "https://raw.githubusercontent.com/cilium/cilium/main/stable.txt"
    cilium_version = Utils.safe_popen_read("curl", cilium_version_url).strip

    ldflags = %W[
      -s -w
      -X github.com/cilium/cilium/cilium-cli/defaults.CLIVersion=v#{version}
      -X github.com/cilium/cilium/cilium-cli/defaults.Version=#{cilium_version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"cilium"), "./cmd/cilium"

    generate_completions_from_executable(bin/"cilium", "completion")
  end

  test do
    assert_match("cilium-cli: v#{version}", shell_output("#{bin}/cilium version"))
    assert_match("Kubernetes cluster unreachable", shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end
