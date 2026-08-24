class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://cadence-lang.org/"
  url "https://github.com/onflow/cadence/archive/refs/tags/v1.10.6.tar.gz"
  sha256 "1ebf30de848ff857b8203fec7eddfdc61b0b3f003a902c94b96eba08c06a489a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c79221eb09307c61592aa6ce92a491ac8e0043e159a53b0413a607fc95ee34d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c79221eb09307c61592aa6ce92a491ac8e0043e159a53b0413a607fc95ee34d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c79221eb09307c61592aa6ce92a491ac8e0043e159a53b0413a607fc95ee34d"
    sha256 cellar: :any_skip_relocation, sonoma:        "20d9e9b98e1288ac49c0f3f49ee67113d843835dd698634d34ccee4b28d3a1c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52bc063e2584e0ed9e3b76b4a6526f113caabbf0d5ca88dc322871ba3910e060"
    sha256 cellar: :any,                 x86_64_linux:  "d09f2679997b95491b04f15a923971aea3b267c44962cdfe7726369ea60696e6"
  end

  depends_on "go" => :build

  conflicts_with "cadence-workflow", because: "both install a `cadence` executable"

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
