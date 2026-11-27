class Oras < Formula
  desc "OCI Registry As Storage"
  homepage "https://oras.land"
  url "https://github.com/oras-project/oras/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "453bda1279b166eb6c2bd84b5995b952403c388ad8eb2f77a9f269011f69788b"
  license "Apache-2.0"
  head "https://github.com/oras-project/oras.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "b29795f6b234333050299f30a17260da438c6f9c79af04e5d44ff131dc918b52"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "04cd59a8abb78106696c3a44023f0f5cfb8b6ac627ef44217614932de7c66633"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "04cd59a8abb78106696c3a44023f0f5cfb8b6ac627ef44217614932de7c66633"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "04cd59a8abb78106696c3a44023f0f5cfb8b6ac627ef44217614932de7c66633"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e0f4a71bef49943a57028ada9a89a9d0e3132c9ed6e5cc97fe12c7cbdb55453e"
    sha256 cellar: :any,                 x86_64_linux:      "c6be3afdf3f15476c88527a352e6070e0febd51f86b4cb82d4b87a2294f1f6fb"
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
