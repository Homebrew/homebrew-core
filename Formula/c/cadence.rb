class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://cadence-lang.org/"
  url "https://github.com/onflow/cadence/archive/refs/tags/v1.6.3.tar.gz"
  sha256 "85499d39a6bb69289456ea5d970cae66f5a87f93412cc9def8bc316903bf9fa2"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ed3947d579791eb7c79f724ba27d8f2a0e466d07c21577d0767dd1b8fc177d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ed3947d579791eb7c79f724ba27d8f2a0e466d07c21577d0767dd1b8fc177d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9ed3947d579791eb7c79f724ba27d8f2a0e466d07c21577d0767dd1b8fc177d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f13ac09f405fd2906ed101249b8ff0e37c6793c87c3a572ce770e716deed413"
    sha256 cellar: :any_skip_relocation, ventura:       "3f13ac09f405fd2906ed101249b8ff0e37c6793c87c3a572ce770e716deed413"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57c3ca6f72452a7018b27cc722f18f2c00602d8d5256a0e3227cc82878c282f7"
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
