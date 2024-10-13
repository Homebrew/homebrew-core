class Oras < Formula
  desc "OCI Registry As Storage"
  homepage "https://github.com/oras-project/oras"
  url "https://github.com/oras-project/oras/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "1f3fc661c90cfb48b4b0e6ef4817b86b28c784186ab0da1a778809938899f574"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0705e9053e6f8b28cf33803ac773155caeb7e0b6e05fd74e5645fd6a0c7ddb74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "39be70a7b4aac808e25b709af739e31dd0ae603fafb4de0658acc048efdd9737"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "947956b2f31faa3de29aec4fd088ce81a5ee7e939983b098bee681dcb63ee0cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e60745c2ec96984b3365f3be35cc1fdeb372fa1f94b0ddc666164d4c8ce9064"
    sha256 cellar: :any_skip_relocation, sonoma:         "e529d2078e74cae581302907d4379d1d1f75a3b8cd6b65d1a3954f23e06c0ef8"
    sha256 cellar: :any_skip_relocation, ventura:        "ab0f9925c3a0c0283921fadeeef90501eefdaa1aa5ffe204e71a09c9a6212a0c"
    sha256 cellar: :any_skip_relocation, monterey:       "2b6792add6a10a3bfde8eb5d3fb61e7b886a6caf06f72d9b2bd0ff18c3005e61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f803a982ff6bfe2c949014ee82d4c3cfdcfb5180b320a1513259a853a546045"
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
