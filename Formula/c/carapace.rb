class Carapace < Formula
  desc "Multi-shell multi-command argument completer"
  homepage "https://carapace.sh"
  url "https://github.com/carapace-sh/carapace-bin/archive/refs/tags/v1.8.5.tar.gz"
  sha256 "e301baf4c1921d22da98e01813dadb7c1c6db435120c3e9db5b4e209e307d5dd"
  license "MIT"
  head "https://github.com/carapace-sh/carapace-bin.git", branch: "master"

  bottle do
    manifest_sha256 "5dd66a1b42ab4fc6750e080d975a88a066b8028ace9f171dfabe63ebf82a8ad5"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "021e6609521711aebbee7851cdb4aefdaf7b67b6d591cfe2d8133d36f75bf9cc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "021e6609521711aebbee7851cdb4aefdaf7b67b6d591cfe2d8133d36f75bf9cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "021e6609521711aebbee7851cdb4aefdaf7b67b6d591cfe2d8133d36f75bf9cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2fec7feb65da44f729a699b22b8ba222a9cbe5b938491cb29fcd23353bc21934"
    sha256 cellar: :any,                 x86_64_linux:      "d5dd15bf3c562f48d97fe7fbe04a6208153a93b9ca3d6421b6ce6cf0d785800d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "generate", "./..."
    ldflags = %W[-X main.version=#{version}]
    system "go", "build", *std_go_args(ldflags:, tags: "release"), "./cmd/carapace"

    generate_completions_from_executable(bin/"carapace", "carapace")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/carapace --version 2>&1")

    system bin/"carapace", "--list"
    system bin/"carapace", "--macro", "color.HexColors"
  end
end
