class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://cadence-lang.org/"
  url "https://github.com/onflow/cadence/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "c4cfc6ecf2d4ed145458c99e58f6664f69d4b0eeb22f2fe1548d50fbda219de5"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ddaaec0e5c1c6c0b6f1bbe4c36dcda6c5db623afe86798f7d7d566b2086f1ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ddaaec0e5c1c6c0b6f1bbe4c36dcda6c5db623afe86798f7d7d566b2086f1ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ddaaec0e5c1c6c0b6f1bbe4c36dcda6c5db623afe86798f7d7d566b2086f1ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "76aa8a432804cb42d012f870e28e8941a1c9ea7e392128551303062080f65067"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0072188b8d4194b1d9d0296e4288ee85987efd898606a1a65a886a0891310dc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27fac746fe23b6a2bd6bb0b3a3a6f9ea368bb5b018fcad28448bf5e28ec9be63"
  end

  depends_on "go" => :build

  conflicts_with "cadence-workflow", because: "both install a `cadence` executable"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/main"
  end

  test do
    # from https://cadence-lang.org/docs/tutorial/hello-world
    (testpath/"hello.cdc").write <<~EOS
      access(all) contract HelloWorld {

          // Declare a public (access(all)) field of type String.
          //
          // All fields must be initialized in the initializer.
          access(all) let greeting: String

          // The initializer is required if the contract contains any fields.
          init() {
              self.greeting = "Hello, World!"
          }

          // Public function that returns our friendly greeting!
          access(all) view fun hello(): String {
              return self.greeting
          }
      }
    EOS
    system bin/"cadence", "hello.cdc"
  end
end
