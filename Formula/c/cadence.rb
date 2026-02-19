class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://cadence-lang.org/"
  url "https://github.com/onflow/cadence/archive/refs/tags/v1.9.9.tar.gz"
  sha256 "f4e0aa6338cb209c9e8ccc556e18664d85abcb42c1571c537e34e84420de3a97"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a06f408c99ba6575ccf624e2e2c9c1de5aadcb67864bde7a87a9b46a96c4b9e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a06f408c99ba6575ccf624e2e2c9c1de5aadcb67864bde7a87a9b46a96c4b9e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a06f408c99ba6575ccf624e2e2c9c1de5aadcb67864bde7a87a9b46a96c4b9e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1f3c62e01f562cd064b6ddc204ef7f3005f0fa9380af697a1a29663722b607a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4aa47bd5d1f2166e706357df1c7cb5817cae4baffbf623c2966281a596118ae5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "439440c94bacf145e44afcee2009887f6d17ddf559168c199c67950432ed77e9"
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
