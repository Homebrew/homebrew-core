class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://cadence-lang.org/"
  url "https://github.com/onflow/cadence/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "f5c007576d64a9db7462c0810d46e89ecd4ef71450d24f10a6406c6bbdcf450a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dcbc7a819eeb672871fc5b2744d7f3d7bb08d4b19d369fb7ebe40c8ef83b8145"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcbc7a819eeb672871fc5b2744d7f3d7bb08d4b19d369fb7ebe40c8ef83b8145"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcbc7a819eeb672871fc5b2744d7f3d7bb08d4b19d369fb7ebe40c8ef83b8145"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dcbc7a819eeb672871fc5b2744d7f3d7bb08d4b19d369fb7ebe40c8ef83b8145"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e35fda581a4ed96dede920aff5259049cf1ba8eea0fdfce863fce2413f8b55d"
    sha256 cellar: :any_skip_relocation, ventura:       "3e35fda581a4ed96dede920aff5259049cf1ba8eea0fdfce863fce2413f8b55d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bd200d72357a27d6e04db9d20ea015a590064a7ab0c0fb6b336465b09277b11"
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
