class GoPassboltCli < Formula
  desc "CLI for passbolt"
  homepage "https://www.passbolt.com/"
  url "https://github.com/passbolt/go-passbolt-cli/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "a1956f16f207ee63fa6f6373ec93c9e3e4f9fc406af6424ac3ddd6962de11d14"
  license "MIT"
  head "https://github.com/passbolt/go-passbolt-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7ae2dbbdd9a6e7adb0f39a35d2e9ac1c9ee1b0203bc941213497f5a0827a4504"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9672c3e8ed85c6aacfddd23df747a5adb33afc94a2df63a50dc01c89e261dc0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9672c3e8ed85c6aacfddd23df747a5adb33afc94a2df63a50dc01c89e261dc0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "9672c3e8ed85c6aacfddd23df747a5adb33afc94a2df63a50dc01c89e261dc0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b17aee4c4c92cc4982dc4e107342bc68f5ecb5cd6a865a6b826dc530a8db9e3d"
    sha256 cellar: :any,                 x86_64_linux:      "50d3740c4ab7e97cabb8ef66bf9983070d4cbfa38eea6fdf82e8f424e0dfef6b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"passbolt")

    generate_completions_from_executable(bin/"passbolt", shell_parameter_format: :cobra)
    mkdir "man"
    system bin/"passbolt", "gendoc", "--type", "man"
    man1.install Dir["man/*.1"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/passbolt --version")
    assert_match "Error: serverAddress is not defined", shell_output("#{bin}/passbolt list user 2>&1", 1)
  end
end
