class Oras < Formula
  desc "OCI Registry As Storage"
  homepage "https://github.com/oras-project/oras"
  url "https://github.com/oras-project/oras/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "0fc82da7f0938ae32201c258a36499453d114cc4bce93dd2aa21a34a7b660d35"
  license "Apache-2.0"
  head "https://github.com/oras-project/oras.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d638010fe839ef19033aa35d254c4ba246112a0699d682bf426976d5401b617"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d638010fe839ef19033aa35d254c4ba246112a0699d682bf426976d5401b617"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d638010fe839ef19033aa35d254c4ba246112a0699d682bf426976d5401b617"
    sha256 cellar: :any_skip_relocation, sonoma:        "42d2ff6d5eb85f62f843b6f227932d4f9cf88565b48855fc6c078a0f8fe74adb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4bbd72ec2a9d21aa6ba1cd9bb5932d2413740711954394a143027acc13f85bbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4492f5d6efc5013622cf99be1325f7759a1d4feec80f34ad22f149202d04dda"
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
