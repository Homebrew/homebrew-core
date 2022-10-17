class Oras < Formula
  desc "OCI Registry As Storage"
  homepage "https://github.com/oras-project/oras"
  url "https://github.com/oras-project/oras/archive/v0.15.1.tar.gz"
  sha256 "09401a5f63e7c9f74d9e42cc7359fc4c691eb910dd82e7826af12c35beca73fa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97aee764f53afea6769d128c51867cc8aeb8077270822145949266c76c991d6d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a69be9d099cc1e84c70224a5fef180c7634c4cadb9c15686720af7f7abfc7c8"
    sha256 cellar: :any_skip_relocation, monterey:       "23d29560383e3811569fecdb279f8af9358b1a6d7b2ee0ff10a8b85033d885e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "3eb73a66901b4ef3574125e3cee0d0bf8525c000d0cf3525fb9b16be4fd4efae"
    sha256 cellar: :any_skip_relocation, catalina:       "f866574e310c3a78364726b17c2869eabe8ca3169d351bc0b00fb65f70a6e032"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02ad29bc59aea4bad4cd916a4758254852ef9b43c5a88b05ab39956df0d5e24d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X oras.land/oras/internal/version.Version=#{version}
      -X oras.land/oras/internal/version.BuildMetadata=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/oras"
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
