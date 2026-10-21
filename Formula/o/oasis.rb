class Oasis < Formula
  desc "CLI for interacting with the Oasis Protocol network"
  homepage "https://github.com/oasisprotocol/cli"
  url "https://github.com/oasisprotocol/cli/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "90dc2f6c643265dd5a14b1ddfcb29e7187acbf1059592ad593d5aa108ed1614c"
  license "Apache-2.0"
  head "https://github.com/oasisprotocol/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e79f052c4862f35516a360120cb3f3852c26da6bffb247eb8c3c4e3ed9593c7a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "39c3529956da5097cc70104f9c0bc4794fd190e4ae3ee274584896d98942eb50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fbb5ebcc18b64620145509e0d045ac8bb3e163c243fe91d180be3c4afce59fa5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4a6246c6078236ecbb901d1c8e9530a126127f98da833653b542337c4846c77e"
    sha256 cellar: :any,                 x86_64_linux:      "65e2e6d4d971256a039a2234ccdeea6874b4f2403eea37de8fc123fe81d33c90"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/oasisprotocol/cli/version.Software=#{version}
      -X github.com/oasisprotocol/cli/cmd.DisableUpdateCmd=true
    ]

    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"oasis", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oasis --version")
    assert_match "CLI for interacting with the Oasis network", shell_output("#{bin}/oasis --help")
    assert_match "Error: unknown command \"update\" for \"oasis\"", shell_output("#{bin}/oasis update 2>&1", 1)
    assert_match "Error: no address given and no wallet configured", shell_output("#{bin}/oasis account show 2>&1", 1)
  end
end
