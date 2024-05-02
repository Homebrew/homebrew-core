class Oras < Formula
  desc "OCI Registry As Storage"
  homepage "https://github.com/oras-project/oras"
  url "https://github.com/oras-project/oras/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "87059bbf96781980ba9826603ee10e2bb3cfafbe7b9410ba1c65fe336b9d4ee0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ccaba33982008f43f7793453a2e05e77947f72c7ba50f060ee42618170d96a71"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f81b5e0b9be89eb8695154cd5d8adfbc5fe5f54776e5384088c7808dc79457a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbfdd30ff5262d0b25c6098aedc220c44cfce8c8a4b98e4972b0dbdc3a2489ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa17865465a26fa693a861d1d3333dfa33b1d2bfd4177f8b28d3809ca8c8de92"
    sha256 cellar: :any_skip_relocation, sonoma:         "cf8bb9227d55b0b4e47811c07876f6d790b8eb88c0638b04ec242d6fe8bd46cd"
    sha256 cellar: :any_skip_relocation, ventura:        "392796efd0bde2575b9e7d1b2c7eeff86cd6518f32061ee23e698ac3fed95840"
    sha256 cellar: :any_skip_relocation, monterey:       "4f05a3f7d50deebe6bd4a7b64afab15c02be52858608c77b808d7c2607efc6c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac8b789e597663dfb719a6381b37d5892b7540e588ebbf67fd858ff1759216a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e1b9ed792c372bc02535f661e1d4d089d0ae01e31de7be0251c76b0e87316bd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X oras.land/oras/internal/version.Version=#{version}
      -X oras.land/oras/internal/version.BuildMetadata=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/oras"

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
