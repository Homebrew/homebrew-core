class Oras < Formula
  desc "OCI Registry As Storage"
  homepage "https://github.com/oras-project/oras"
  url "https://github.com/oras-project/oras/archive/v0.16.0.tar.gz"
  sha256 "37bac099dd72de50cf2405dd092908b1039db142faf81ab1c9d22ced2e0d1ea6"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c27f931c71ab78701e8d91d56fa88695bde78840ccef66fb8ada14c9dcadf2fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3802c90a5cdd03d1ccfa22523fa9285d4085abf18851a8658eb014c4dbcbe0e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a740997cc8c15d73aee2584e346a1438bdff5782a127dfd66d7cb0d02b803843"
    sha256 cellar: :any_skip_relocation, ventura:        "8700ad4b886f826426047691f37b596979a8a7908f3e673dfdd9b52ad0aa8317"
    sha256 cellar: :any_skip_relocation, monterey:       "6e5ea3a26af5c37badf8703a0aad7948dafba5359b9f6a90b107957a0088a36c"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1733afa2e23e7fe8d927df04cf25f5eb99a2f27f3664bc17ab68b0228588db9"
    sha256 cellar: :any_skip_relocation, catalina:       "183a997ecf29e06fb92704d3a09cad4468284bbf9f99ee2a4bfdcf289a563936"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e0a1bae87169064386c19b4348aa79cdd03950a048b7a0087f0e11a99af215f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X oras.land/oras/internal/version.Version=#{version}
      -X oras.land/oras/internal/version.BuildMetadata=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/oras"

    generate_completions_from_executable(bin/"oras", "completion")
  end

  test do
    assert_match "#{version}+Homebrew", shell_output("#{bin}/oras version")

    port = free_port
    contents = <<~EOS
      {
        "key": "value",
        "this is": "a test"
      }
    EOS
    (testpath/"test.json").write(contents)

    # Although it might not make much sense passing the JSON as both manifest and payload,
    # it helps make the test consistent as the error can randomly switch between either hash
    output = shell_output("oras push localhost:#{port}/test-artifact:v1 " \
                          "--config test.json:application/vnd.homebrew.test.config.v1+json " \
                          "./test.json 2>&1", 1)
    assert_match "#{port}: connect: connection refused", output
  end
end
