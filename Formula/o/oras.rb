class Oras < Formula
  desc "OCI Registry As Storage"
  homepage "https://github.com/oras-project/oras"
  url "https://github.com/oras-project/oras/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "33a44023666e00b6e32b5bd022a77f0813a488bdeab90c7d728b811d5f97df48"
  license "Apache-2.0"
  head "https://github.com/oras-project/oras.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7854879fac23c228f80368e88f0836825a5969c028d06d3550f2912fa51ac6a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7854879fac23c228f80368e88f0836825a5969c028d06d3550f2912fa51ac6a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7854879fac23c228f80368e88f0836825a5969c028d06d3550f2912fa51ac6a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "23b787ed090524b9988d6098e9bd1f39fd06fa2f71c99f2071befac3c66b7ac6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9320a667afc254c4bcfcabaa2abf652a445a23ad5652f3e4932d905c37db943a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44ba928ae32fb6b7ada4583648b641daf0767874a148ac3e9c8db55f886faef0"
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
