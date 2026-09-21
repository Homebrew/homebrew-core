class Oras < Formula
  desc "OCI Registry As Storage"
  homepage "https://oras.land"
  url "https://github.com/oras-project/oras/archive/refs/tags/v1.3.4.tar.gz"
  sha256 "0967062b09d82c902e7f6bdd22fc6dd4577811bf46ba63dab8791ff047c55392"
  license "Apache-2.0"
  head "https://github.com/oras-project/oras.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "40e443807ac98f5dd3f21b92ce0f34c001d81ff0430e3d0d32686eaad44f3b4b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1749e36c351467261a270c29a89f0e87059829f56899f0a6dcdd8a3938fb833e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1749e36c351467261a270c29a89f0e87059829f56899f0a6dcdd8a3938fb833e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "1749e36c351467261a270c29a89f0e87059829f56899f0a6dcdd8a3938fb833e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "292ce96bfa33eca540ba1ebf6297ffb180c131f0908482edf3fe45672759edea"
    sha256 cellar: :any,                 x86_64_linux:      "ce9c2d062d70f4cd4a627fa2bc566e5c4df150298b3ac69d95fe6e3841984229"
  end

  depends_on "go" => :build

  # `test do` block binds a local port
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X oras.land/oras/internal/version.Version=#{version}
      -X oras.land/oras/internal/version.BuildMetadata=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/oras"

    generate_completions_from_executable(bin/"oras", shell_parameter_format: :cobra)
  end

  test do
    assert_match "#{version}+Homebrew", shell_output("#{bin}/oras version")

    port = free_port
    contents = <<~JSON
      {
        "key": "value",
        "this is": "a test"
      }
    JSON
    (testpath/"test.json").write(contents)

    # Although it might not make much sense passing the JSON as both manifest and payload,
    # it helps make the test consistent as the error can randomly switch between either hash
    output = shell_output("#{bin}/oras push localhost:#{port}/test-artifact:v1 " \
                          "--config test.json:application/vnd.homebrew.test.config.v1+json " \
                          "./test.json 2>&1", 1)
    assert_match "#{port}: connect: connection refused", output
  end
end
