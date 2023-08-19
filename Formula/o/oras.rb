class Oras < Formula
  desc "OCI Registry As Storage"
  homepage "https://github.com/oras-project/oras"
  url "https://github.com/oras-project/oras/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "c0750d1837c449232ad8459dea55a7c660d822ce2d17a8a7882bfc3518b01646"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8690763d0a9d0be6574ee4cfdb8edbab302f232c8056bae2d0083f170719afed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8690763d0a9d0be6574ee4cfdb8edbab302f232c8056bae2d0083f170719afed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8690763d0a9d0be6574ee4cfdb8edbab302f232c8056bae2d0083f170719afed"
    sha256 cellar: :any_skip_relocation, ventura:        "7aa41c77868644a275e722b7cb9230296721ac0c31a467391164ded69d985773"
    sha256 cellar: :any_skip_relocation, monterey:       "7aa41c77868644a275e722b7cb9230296721ac0c31a467391164ded69d985773"
    sha256 cellar: :any_skip_relocation, big_sur:        "7aa41c77868644a275e722b7cb9230296721ac0c31a467391164ded69d985773"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4e378e9d1ec53a8aae7817d58c57522e92d99e2e3aac735555650063aee6742"
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
