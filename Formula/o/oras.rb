class Oras < Formula
  desc "OCI Registry As Storage"
  homepage "https://oras.land"
  url "https://github.com/oras-project/oras/archive/refs/tags/v1.3.5.tar.gz"
  sha256 "692a594bd59353221c4a387e3744d084b44cd73cf52e811c4672c7f9eda3527d"
  license "Apache-2.0"
  head "https://github.com/oras-project/oras.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "548bea3cdcb8de418c69ec8f32337a92261378831f9c717c24545505949de092"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "548bea3cdcb8de418c69ec8f32337a92261378831f9c717c24545505949de092"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "548bea3cdcb8de418c69ec8f32337a92261378831f9c717c24545505949de092"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e3b743d9fce778a112f151c38a7911d0a5cb34e3c37c339181795242e3e31a59"
    sha256 cellar: :any,                 x86_64_linux:      "bcf511ea6e230bb726da54cfca7f011d2b69b2aabfc8e6fa88e33f95418fdef9"
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
