class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://github.com/massdriver-cloud/mass/archive/refs/tags/2.6.0.tar.gz"
  sha256 "6d3566c185a969a10aa776099c07103726d5b186cf789a7e48dd0709e73d6e0f"
  license "Apache-2.0"
  head "https://github.com/massdriver-cloud/mass.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "fd9a9f8b67750ef9bc2c06258ac5b5fbbc892a027ac9f83c175bc9adf3d4ebc4"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "af7d3f264998de988b3ed350841e505f4e0073ee6b20e27c09e89fcdf5e3a517"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "af7d3f264998de988b3ed350841e505f4e0073ee6b20e27c09e89fcdf5e3a517"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "af7d3f264998de988b3ed350841e505f4e0073ee6b20e27c09e89fcdf5e3a517"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "aeab0b9cc777ca6985e45242f4aa48e45601a99df891250968bfdc0bcc0cb357"
    sha256 cellar: :any,                 x86_64_linux:      "d337d906590f791647845555779da371bee005e9a28e681055235c2f06e44008"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/massdriver-cloud/mass/internal/version.version=#{version}
      -X github.com/massdriver-cloud/mass/internal/version.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"mass")

    generate_completions_from_executable(bin/"mass", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mass version")

    ENV["MASSDRIVER_ORGANIZATION_ID"] = "homebrew"
    ENV["MASSDRIVER_API_KEY"] = "test"
    output = shell_output("#{bin}/mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output
  end
end
