class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.app/"
  url "https://github.com/danvergara/dblab/archive/refs/tags/v0.34.2.tar.gz"
  sha256 "fdcf88a1b4bbfea0d401a8ed13b930408e6fd85bde341565cb7a7a649a274d94"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be097cf2cf94dbb10382dc368996a9c95b32865554f1e9a7acc23fa3c9d17e26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a2e16b662a989bb2d732a07266615f44dfbcb2c3fe3eaf1b32e1f87b1ef82bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9dd0afebfc7e381b9768647680bd8ef9f7e7ff7a5fb4045ae7c37ae0e1f73897"
    sha256 cellar: :any_skip_relocation, sonoma:        "8378b8e347bddbd141046e1730fa6aeb328e38a0a57d080aaeb7e38c4ba72cd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90871ef01ab6711087c15e2492a0c22621887c808ad8e88daab39d34556fdf2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52c4d6943a392e8b2f56ebc43419b71f5fda6390d4cb824fda9fd2b5cf015216"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"dblab", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dblab --version")

    output = shell_output("#{bin}/dblab --url mysql://user:password@tcp\\(localhost:3306\\)/db 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end
