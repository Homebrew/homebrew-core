class Oras < Formula
  desc "OCI Registry As Storage"
  homepage "https://github.com/oras-project/oras"
  url "https://github.com/oras-project/oras/archive/v1.0.0.tar.gz"
  sha256 "1515f84ebad7dfce80edc7fd1771caf312b4d84c348832c34e8dd77f7d4374cb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "999c6c836e1c77915bad96be54b29960a53b4f146b4e7d0eba94701976287156"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "999c6c836e1c77915bad96be54b29960a53b4f146b4e7d0eba94701976287156"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "999c6c836e1c77915bad96be54b29960a53b4f146b4e7d0eba94701976287156"
    sha256 cellar: :any_skip_relocation, ventura:        "4243fa70f6048a2e3ecfc93f43dabe2ecc51aa64a373dbda7e24d700d5561fda"
    sha256 cellar: :any_skip_relocation, monterey:       "4243fa70f6048a2e3ecfc93f43dabe2ecc51aa64a373dbda7e24d700d5561fda"
    sha256 cellar: :any_skip_relocation, big_sur:        "4243fa70f6048a2e3ecfc93f43dabe2ecc51aa64a373dbda7e24d700d5561fda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cb641af3dc83987f1a279e0b0f802ab2ada4ac92e6bdf9b86070b34f15f9117"
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
    output = shell_output("#{bin}/oras push localhost:#{port}/test-artifact:v1 " \
                          "--config test.json:application/vnd.homebrew.test.config.v1+json " \
                          "./test.json 2>&1", 1)
    assert_match "#{port}: connect: connection refused", output
  end
end
