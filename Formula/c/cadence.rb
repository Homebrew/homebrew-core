class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://cadence-lang.org/"
  url "https://github.com/onflow/cadence/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "254eac4effc940cd285b1399960ec3d61618eb9241a039e7d5eeb37fc671ca57"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4abdc7603278eed737a4c145eda48cbff5f55f7ebb3c55d9a4b2ad698a155fb5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4abdc7603278eed737a4c145eda48cbff5f55f7ebb3c55d9a4b2ad698a155fb5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4abdc7603278eed737a4c145eda48cbff5f55f7ebb3c55d9a4b2ad698a155fb5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d355e65ff50026cc7026f49159a9b73eb8415aac5982b86deb71ad379ebf0c6d"
    sha256 cellar: :any_skip_relocation, ventura:       "d355e65ff50026cc7026f49159a9b73eb8415aac5982b86deb71ad379ebf0c6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f99332bc1a054f054628f3ee0fb650828e183471f229ae478bbbf123179c72d4"
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
