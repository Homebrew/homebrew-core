class Hookdeck < Formula
  desc "Forward webhook events from Hookdeck to a local server"
  homepage "https://hookdeck.com"
  url "https://github.com/hookdeck/hookdeck-cli/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "6926f7f18dd78a4c0f501bba9b49898d21253558ae4dbb0064d4f665307a1839"
  license "Apache-2.0"
  head "https://github.com/hookdeck/hookdeck-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "802ba70c17cf929e0189e9d22800ea31458a52be31e5c0b1a8dc903e339d10d0"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "32f9e58d7d94aa8fc9229df3620f3522ab396ae2543b40607abd5490b89cb53d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "32f9e58d7d94aa8fc9229df3620f3522ab396ae2543b40607abd5490b89cb53d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "32f9e58d7d94aa8fc9229df3620f3522ab396ae2543b40607abd5490b89cb53d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "05a5444475346d75617037ca70094ba0e68069181ca25cad24a71aaa71032942"
    sha256 cellar: :any,                 x86_64_linux:      "4475a703ddd0d0c2f98f81acf4971e6d93d548adf7de4483844eb546c90ebe2f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/hookdeck/hookdeck-cli/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"hookdeck", "completion",
                                         shell_parameter_format: "--shell=",
                                         shells:                 [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hookdeck --version")
    assert_match "Provide a project API key", shell_output("#{bin}/hookdeck ci 2>&1", 1)
  end
end
