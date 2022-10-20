class Oras < Formula
  desc "OCI Registry As Storage"
  homepage "https://github.com/oras-project/oras"
  url "https://github.com/oras-project/oras/archive/v0.15.1.tar.gz"
  sha256 "09401a5f63e7c9f74d9e42cc7359fc4c691eb910dd82e7826af12c35beca73fa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "329d1d046fbd12c1882ab54838eccc8d4ef056f04b351affdfe7b8f5ca18a566"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c11fe5f80f3239918f02a8efebcfb70f1493d49e5cc938d4ca0fdfd36c4d318d"
    sha256 cellar: :any_skip_relocation, monterey:       "7051d6f25f135a5c3cfe3122279110544d6be3b294e989d6d672b507ceb05e2a"
    sha256 cellar: :any_skip_relocation, big_sur:        "69e8896fb9b46b84ad597580baef343fb92ad3c5c2cb84396f0ad508c0a87bac"
    sha256 cellar: :any_skip_relocation, catalina:       "fc261d350b61b76c38a259646a154790ed09be03e775b7292f46edd2806ab1f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3aeaab39f2801358ead63858ffdd9c1d6758c93d2672543ee1333d7c2c5df6e"
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
