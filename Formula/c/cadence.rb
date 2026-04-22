class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://cadence-lang.org/"
  url "https://github.com/onflow/cadence/archive/refs/tags/v1.10.2.tar.gz"
  sha256 "cfcb6544880e296ca8c64aab2a8440d4af38c60e0dd8dfbcd6e7e0b4862e7db2"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d93eae81b2c8aee73f20e401cadf206c9abec792d12352fadc0ed0190410ece3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d93eae81b2c8aee73f20e401cadf206c9abec792d12352fadc0ed0190410ece3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d93eae81b2c8aee73f20e401cadf206c9abec792d12352fadc0ed0190410ece3"
    sha256 cellar: :any_skip_relocation, sonoma:        "b204f2ed05b22536b08a94151fcce12e56486c7cbcae870849e37f381903f0a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "053b3fa7c42ee03785f1805f9ecf5468e703503d21d0b9e5ee6cadec772c80c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9acec8a9f60411a86bee476b264093505e71eef43640b5add543ecbfa4b2921"
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
