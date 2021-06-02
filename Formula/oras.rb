class Oras < Formula
  desc "OCI Registry As Storage"
  homepage "https://github.com/oras-project/oras"
  url "https://github.com/oras-project/oras/archive/v0.12.0.tar.gz"
  sha256 "5e19d61683a57b414efd75bd1b0290c941b8faace5fcc9d488f5e4aa674bf03e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7df64201010ee88df6b42e9b4c7366c584db8f661f3892327333bc1d2b72b1b6"
    sha256 cellar: :any_skip_relocation, big_sur:       "58f25965a9deb06395e3c73b6526ce48c65b837c9173b56780084501626d038e"
    sha256 cellar: :any_skip_relocation, catalina:      "4a71d2ffb060d9b66c3c21ebad5f40433cb544ef406714d0756eb5a72a639c13"
    sha256 cellar: :any_skip_relocation, mojave:        "008def6b863c4c2d40408d6298f89146149bfa67d6845a8fe8990329b19f59fb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/oras-project/oras/internal/version.Version=#{version}
      -X github.com/oras-project/oras/internal/version.BuildMetadata=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags: ldflags.join(" ")), "./cmd/oras"
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
    hash = Digest::SHA256.hexdigest(contents)

    # Although it might not make much sense passing the JSON as both manifest and payload,
    # it helps make the test consistent as the error can randomly switch between either hash
    output = shell_output("oras push localhost:#{port}/test-artifact:v1 " \
                          "--manifest-config test.json:application/vnd.homebrew.test.config.v1+json " \
                          "./test.json 2>&1", 1)
    assert_match %r{
       ^Error:\ failed\ to\ do\ request(.*)
       http://localhost:#{port}/v2/test-artifact/blobs/sha256:#{hash}
    }x, output
  end
end
