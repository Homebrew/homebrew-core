class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://cadence-lang.org/"
  url "https://github.com/onflow/cadence/archive/refs/tags/v1.10.3.tar.gz"
  sha256 "10c5512caf61205e5941b314e9a9ba17682e1c2fdaa29f451f2e2a1958d79f37"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2353c232773359ed9b596b1ec284840abff4973c3dc1e202705a1bbdf1e757a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2353c232773359ed9b596b1ec284840abff4973c3dc1e202705a1bbdf1e757a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2353c232773359ed9b596b1ec284840abff4973c3dc1e202705a1bbdf1e757a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fa6099577e55ae1e430e77a9c550e48ac1510dee51531cd75379c13e151d768"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23b25a6c778270596e2ff7e3614a2cc36ee5324cd06440c935d15af43c08d77f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e141369863f8397cf7d5eed7357348e4287cd74aacbb9a47185eb921557f43f3"
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
