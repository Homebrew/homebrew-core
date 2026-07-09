class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://cadence-lang.org/"
  url "https://github.com/onflow/cadence/archive/refs/tags/v1.10.4.tar.gz"
  sha256 "1676685d0041d37afa3f98bd09766a6e65b67c05f8544e1b142f7878bcf999d7"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58aa02cd7d79e5ab920e87259608ece02efe666e8f69701cffdbe8f1332a5092"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58aa02cd7d79e5ab920e87259608ece02efe666e8f69701cffdbe8f1332a5092"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58aa02cd7d79e5ab920e87259608ece02efe666e8f69701cffdbe8f1332a5092"
    sha256 cellar: :any_skip_relocation, sonoma:        "8345957fffbf56b7dabd01d3b89a2090b99050d7b0d0d68a2a30ebba04b0d0f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bbdedc42b0f4043351333864da7d054f85509eb567a490e23fc182af8421def"
    sha256 cellar: :any,                 x86_64_linux:  "89fa91cb986e7c5c7247db80a2f9b7a6d1aa54d80eb70b2b898961705961b04c"
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
