class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://cadence-lang.org/"
  url "https://github.com/onflow/cadence/archive/refs/tags/v1.8.7.tar.gz"
  sha256 "a030565850e26c84d664301532f161dbe228d3dc5112359c256d81b28eb79a36"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0caa62524443af903e7a343e1a6f88cee4fcb1202470de10f30f20ae6455f5fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0caa62524443af903e7a343e1a6f88cee4fcb1202470de10f30f20ae6455f5fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0caa62524443af903e7a343e1a6f88cee4fcb1202470de10f30f20ae6455f5fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "35fc4a3af96a887d835cb8334c46f24d951da9b6d6f9ce9731d4833fa33e498d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ebe354527f7044801184446e97b921c25222b6c88f8cf3f757d3e983c05d32f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba5cdcc0077ef01f619f94becf087fec7037adbc86cba16a10ad6915dcb6c0ae"
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
