class Oras < Formula
  desc "OCI Registry As Storage"
  homepage "https://github.com/oras-project/oras"
  url "https://github.com/oras-project/oras/archive/v0.14.1.tar.gz"
  sha256 "29e934ef24092209c488a411a89af80cfcd93a4c880a36192e91085a58f0c2f7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a28d0437bddfc6a78c78706b1f1dbd8a26def3afa3da6ff4a012dcc084582a7a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "db51930370ccb6fdf497b653fbd94d597ab8dc99077eb8667a1993851797e175"
    sha256 cellar: :any_skip_relocation, monterey:       "130eea50cb2822c875a51a82b35913548b2e407cd4150c8215391806e26dcae6"
    sha256 cellar: :any_skip_relocation, big_sur:        "b617248191a2ab42e07cd485a20d5d557c74291931676afbd5bf29b094f428db"
    sha256 cellar: :any_skip_relocation, catalina:       "fd627c28acdaf98248195c78cc8e2a0c8068e7397f185a7b7f77bc0bd405854b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93f3e591bac3df50d4e8aa6deded05d9fe5127985f52221a35c2e6a83f9614ea"
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
