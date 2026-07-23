class Oras < Formula
  desc "OCI Registry As Storage"
  homepage "https://oras.land"
  url "https://github.com/oras-project/oras/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "77170b1c2af19c4d9e0125c98b0709764534b9080de60b94fb3a2952bdce3ebf"
  license "Apache-2.0"
  head "https://github.com/oras-project/oras.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de03e01f23509ff7ba40d2bc0b0dd01040df19e25a14ba2fa87600903f1a5b59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de03e01f23509ff7ba40d2bc0b0dd01040df19e25a14ba2fa87600903f1a5b59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de03e01f23509ff7ba40d2bc0b0dd01040df19e25a14ba2fa87600903f1a5b59"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a80978e2364878e9aa76ca4bbdc9d813f6c077f47b600c666a004a34f9e6772"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a24178505ef17aa22bc6815c5c41a024447e43dfe230ec64d2c3c79c647cdfe"
    sha256 cellar: :any,                 x86_64_linux:  "7f54ab4408b7820c8bdf2ad60de53cb95626426dee50feb2c88badc93337d05c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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
