class Oras < Formula
  desc "OCI Registry As Storage"
  homepage "https://oras.land"
  url "https://github.com/oras-project/oras/archive/refs/tags/v1.3.6.tar.gz"
  sha256 "9a67269f475019a07384bd73004ca308c221674aea0d0dc48e059c61b09bcd54"
  license "Apache-2.0"
  head "https://github.com/oras-project/oras.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "30b7262a0b0b42887d0a163f6ff45d2d9ef56d61edd231328cceadd281dea02a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "30b7262a0b0b42887d0a163f6ff45d2d9ef56d61edd231328cceadd281dea02a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "30b7262a0b0b42887d0a163f6ff45d2d9ef56d61edd231328cceadd281dea02a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6dffcf28d423367c7e611ddd531b92162c82ba024dfb5b6bac010738bcf32ce5"
    sha256 cellar: :any,                 x86_64_linux:      "9f90a26f8bc7b631237f5b77d2e2dca5103e345c6fae92b2500a4b5d3c744ba6"
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
