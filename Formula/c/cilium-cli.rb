class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "48c8bca204d62b9a6a1e8dc13770128e897c21301a2bb88b3b4abf2f2503b9fc"
  license "Apache-2.0"
  head "https://github.com/cilium/cilium-cli.git", branch: "main"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63bacd45aaa63b8611769df7ab8d3c560419db752e3200c381226cf435733a12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e00ef51608811de216ff1357afafc316248a0344db170ba19680ef757b362f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc2a8bb142b86f38d6da8557f550e0287feb63e59dd9dcad9458e1635747d095"
    sha256 cellar: :any_skip_relocation, sonoma:        "3dc250d2c9bc37f8dcc01e0e1bb3e816f4fb5cffea6b6fffccd394011967f78b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47775a54927671eae05c1eed731b4dbf9cab38fe31fc54053aaa2701af859fee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a805bcda6eb78b4728d287fdd36fc96f7d8cc9bade17d0d28df2594374facdb4"
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

    generate_completions_from_executable(bin/"cilium", shell_parameter_format: :cobra)
  end

  test do
    assert_match("cilium-cli: v#{version}", shell_output("#{bin}/cilium version"))
    assert_match("Kubernetes cluster unreachable", shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end
