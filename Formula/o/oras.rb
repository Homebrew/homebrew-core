class Oras < Formula
  desc "OCI Registry As Storage"
  homepage "https://github.com/oras-project/oras"
  url "https://github.com/oras-project/oras/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "f08ddcccaedbb336e85942b6ccb9625c2a7e4e411d5909bd6f670eb0d7ab3977"
  license "Apache-2.0"
  head "https://github.com/oras-project/oras.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc809d29e38e49c915a7df9dcfaa2071638430e5c3c4cd072473a5e98962cc81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc809d29e38e49c915a7df9dcfaa2071638430e5c3c4cd072473a5e98962cc81"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc809d29e38e49c915a7df9dcfaa2071638430e5c3c4cd072473a5e98962cc81"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad350040cacf68be5334bf9ee4b236a2308a2a21ed0e5d303706b881c9ef50e8"
    sha256 cellar: :any_skip_relocation, ventura:       "ad350040cacf68be5334bf9ee4b236a2308a2a21ed0e5d303706b881c9ef50e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12b21aabf4213e0b7e5833a535a4a7942d71290117108d083f0d518025f589f7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X oras.land/oras/internal/version.Version=#{version}
      -X oras.land/oras/internal/version.BuildMetadata=#{tap.user}
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
