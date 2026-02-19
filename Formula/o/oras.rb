class Oras < Formula
  desc "OCI Registry As Storage"
  homepage "https://github.com/oras-project/oras"
  url "https://github.com/oras-project/oras/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "12fc49ddf5c940b0ebba4c318e00b4155b682d590754e0d7330b9c4259b4af51"
  license "Apache-2.0"
  head "https://github.com/oras-project/oras.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50b9ee43b03ad85deed439c627879a6686f54040b60e2df025ca02cdb604e3d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50b9ee43b03ad85deed439c627879a6686f54040b60e2df025ca02cdb604e3d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50b9ee43b03ad85deed439c627879a6686f54040b60e2df025ca02cdb604e3d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0f03ce231df9105b5b87cca36cc7aa5b147ee96b68e190fe937ece22228017f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3cb76ca077a5c8794ff6eb5268a8a1f854e2238f7e6ffac06c243c36b3cf3794"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "766686b5f9c96faf08f48f6c28aa0c0538e456285e4c0a0f933ffb6657ae4d4b"
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
