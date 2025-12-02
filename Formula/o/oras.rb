class Oras < Formula
  desc "OCI Registry As Storage"
  homepage "https://github.com/oras-project/oras"
  url "https://github.com/oras-project/oras/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "12fc49ddf5c940b0ebba4c318e00b4155b682d590754e0d7330b9c4259b4af51"
  license "Apache-2.0"
  head "https://github.com/oras-project/oras.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b88be96c1d2f56331b8abc6b1d9d40a81a308fa7da085b386bbf4a57b4f4748"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b88be96c1d2f56331b8abc6b1d9d40a81a308fa7da085b386bbf4a57b4f4748"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b88be96c1d2f56331b8abc6b1d9d40a81a308fa7da085b386bbf4a57b4f4748"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b88be96c1d2f56331b8abc6b1d9d40a81a308fa7da085b386bbf4a57b4f4748"
    sha256 cellar: :any_skip_relocation, sonoma:        "379b13479f92f19783a1872f3a37f050d71e175afacdfd555374c9b632607e47"
    sha256 cellar: :any_skip_relocation, ventura:       "379b13479f92f19783a1872f3a37f050d71e175afacdfd555374c9b632607e47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b29a94a144c86de81d7879687ddc9f5a1e972d01bfe69382b17c1d5b7bc44d8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce3845f85fa9db76c94a26ba3c0e29894c895fef1232331e1977d48467a22e5a"
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
