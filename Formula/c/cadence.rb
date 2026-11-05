class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://cadence-lang.org/"
  url "https://github.com/onflow/cadence/archive/refs/tags/v1.10.7.tar.gz"
  sha256 "1e87355874f17e088bf4aea45b372d92a028e569ac48af4c09d678dae3fa067b"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "74cfc43fc0071c56d94cea501d02f6c8149912156f97ffea86684445081d6d06"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "74cfc43fc0071c56d94cea501d02f6c8149912156f97ffea86684445081d6d06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "74cfc43fc0071c56d94cea501d02f6c8149912156f97ffea86684445081d6d06"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cf789fb2d8b9e199800e61c0a9c0ab3367dac24cb16239b46ade156c818f4202"
    sha256 cellar: :any,                 x86_64_linux:      "219576bba8a5a17e493a690dc6e12265611901bb99d5bf25e2418d0a1105ca39"
  end

  depends_on "go" => :build

  conflicts_with "cadence-workflow", because: "both install a `cadence` executable"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/main"
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
