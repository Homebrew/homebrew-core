class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://cadence-lang.org/"
  url "https://github.com/onflow/cadence/archive/refs/tags/v1.10.5.tar.gz"
  sha256 "e161d0bc823887fb43b7104162637d22c8d35659093f51ffec23b74879f80fae"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7e55f36f136a9ce70e4590d0911855b3b5af7809c122312e92622e2cdf5345b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7e55f36f136a9ce70e4590d0911855b3b5af7809c122312e92622e2cdf5345b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7e55f36f136a9ce70e4590d0911855b3b5af7809c122312e92622e2cdf5345b"
    sha256 cellar: :any_skip_relocation, sonoma:        "983adf517680a05de10a6de75687e1e013e9fba32da08a675fac22a17810ea42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd6e5f4633cfb35896e636e5d162ee7a558309ea33ee7917cae812e0214deb54"
    sha256 cellar: :any,                 x86_64_linux:  "e1edd2d7180b50ef11b315b1765475dbf4f59a8100fe3e02d7cde315af2af9a9"
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
