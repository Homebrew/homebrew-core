class Oras < Formula
  desc "OCI Registry As Storage"
  homepage "https://github.com/deislabs/oras"
  url "https://github.com/deislabs/oras/archive/v0.10.0.tar.gz"
  sha256 "ace01c2e484ae91f88ecf338daf3a023692acf4e4814c33887f1a66d5a49bb3d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "db532d4af7454d0ed5764d6d9a778a2d5cf55880e9e8699445e0156bc009aa28"
    sha256 cellar: :any_skip_relocation, big_sur:       "2835db4161b5cffad26a3a7ada7ac33742371f31312b632b793d7f47252b6619"
    sha256 cellar: :any_skip_relocation, catalina:      "4be6a79da4194a0e06bb4bb29721a2c7f021979cfd834357840afec7118bb2d9"
    sha256 cellar: :any_skip_relocation, mojave:        "5dbb620dd9fad1e279d618451890d7989706919526ca968fd6c55137bf2dcf8c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/deislabs/oras/internal/version.Version=#{version}
      -X github.com/deislabs/oras/internal/version.BuildMetadata=Homebrew
    ]
    system "go", "build", *std_go_args,
                          "-ldflags", ldflags.join(" "),
                          "./cmd/oras"
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
