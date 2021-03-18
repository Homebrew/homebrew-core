class Oras < Formula
  desc "OCI Registry As Storage"
  homepage "https://github.com/deislabs/oras"
  url "https://github.com/deislabs/oras/archive/v0.11.1.tar.gz"
  sha256 "40416acb056b187544c06d8595553251c77aed27e9e3d7cf455798bcb070f089"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "48e3e62324171ff745c58facc0c2ccebb3694a24ca960a6f65ef374e99cee10e"
    sha256 cellar: :any_skip_relocation, big_sur:       "26d9a53ff1b82bd49c685b50632129c82a65ab60b0f41a8405d3f0c12695f839"
    sha256 cellar: :any_skip_relocation, catalina:      "9b96c43f4b1696bd2db1bea8c5f686baf3ad747c42a0b130c76d8fa3b3a3a8b4"
    sha256 cellar: :any_skip_relocation, mojave:        "d3e49aff7b26c7d7517deb77618a86a092a07c5db9d5874ae25ea6f466f88217"
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
