class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://cadence-lang.org/"
  url "https://github.com/onflow/cadence/archive/refs/tags/v1.8.4.tar.gz"
  sha256 "96d0f36edb7698c95e6c0dc558201a1d53d3307b6703b9e2ae43d83034e61d65"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d214bf3e8d5bd8b93d760193f0eeb4fd54d8cbf14fa6d347649eccde37a8ccba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d214bf3e8d5bd8b93d760193f0eeb4fd54d8cbf14fa6d347649eccde37a8ccba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d214bf3e8d5bd8b93d760193f0eeb4fd54d8cbf14fa6d347649eccde37a8ccba"
    sha256 cellar: :any_skip_relocation, sonoma:        "c901ff0d6757c1c9f1b17ac2d73b4b8c9726ca7ce68e6d301a20cc7a25ee2a87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3bd9dde7c2d1d5c38b5e59d908e6949e3d568ec7687d3f15e6912e1592c3fb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ede5e44d3140ccd6ad87c24b0dfabda30c76c7e85b906df6ab5df5914efc33a"
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
