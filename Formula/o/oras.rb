class Oras < Formula
  desc "OCI Registry As Storage"
  homepage "https://github.com/oras-project/oras"
  url "https://github.com/oras-project/oras/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "09436b3048aab42fdfd5662f71da7d211f9d6e7ce66740cbbd8f3695ae621f6a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0ab4fed3980c7d6975df20975d447004b17c604da7947b2e99d999d55170345"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0ab4fed3980c7d6975df20975d447004b17c604da7947b2e99d999d55170345"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c0ab4fed3980c7d6975df20975d447004b17c604da7947b2e99d999d55170345"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ab9bd7c87e28d26180474be395d27458369dc7225a6618223882d7ef03f6073"
    sha256 cellar: :any_skip_relocation, ventura:       "2ab9bd7c87e28d26180474be395d27458369dc7225a6618223882d7ef03f6073"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf849b37520f25e5fa0c0cef23a23b8b28fe64d51c45465c9cd0024f9dc18d1e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X oras.land/oras/internal/version.Version=#{version}
      -X oras.land/oras/internal/version.BuildMetadata=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/oras"

    generate_completions_from_executable(bin/"oras", "completion")
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
