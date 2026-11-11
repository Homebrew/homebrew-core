class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://github.com/massdriver-cloud/mass/archive/refs/tags/2.5.1.tar.gz"
  sha256 "0922d7d3585f856ccc80da20affaa4bc52472e1de76d2c6c9d92d8233e221766"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a1801730ccfb81683f9fd08681e96e841e2414f4b310ea382aca337795257793"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a1801730ccfb81683f9fd08681e96e841e2414f4b310ea382aca337795257793"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a1801730ccfb81683f9fd08681e96e841e2414f4b310ea382aca337795257793"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "79570fdbabe4936b074c6f70aee08d4e74deac3993befcb423bd27205eb85bf9"
    sha256 cellar: :any,                 x86_64_linux:      "3b46e2a7cb6bb60af766da631b7d67ec6213e7d02d4304dd7add8bdd74e88621"
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
