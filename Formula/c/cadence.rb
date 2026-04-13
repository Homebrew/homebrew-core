class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://cadence-lang.org/"
  url "https://github.com/onflow/cadence/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "5be6ae17fb768e90f87aafc0a9c235476eae0b201fe1b8a42e38c73ed622ea90"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35802a08df5ccb9989e45e0d2afb6052f8f2828809ea0bd9861da05516e9693e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35802a08df5ccb9989e45e0d2afb6052f8f2828809ea0bd9861da05516e9693e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35802a08df5ccb9989e45e0d2afb6052f8f2828809ea0bd9861da05516e9693e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9a06c6ea72c4da13a6d8fb6c79aa8ea6aed0a3bae55f99930f8aceef1dbdd6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e5c92ee06a6a1e34fc7128c7302ae367385b773121c3624fd49f51f1df85115"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e887fa4731f5661bd0b2dca94b2f5dd279c72ebb1ca40f736cb93ce195002d5"
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
