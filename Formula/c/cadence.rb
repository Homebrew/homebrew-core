class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://cadence-lang.org/"
  url "https://github.com/onflow/cadence/archive/refs/tags/v1.3.4.tar.gz"
  sha256 "09f319e46ae4ef989bacd3e283674336084f5e788fb69dfdaab573236d73773f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa7f64a3c70cb7e97d4fa4be2e2ddbb9ca7a28b0f39dbcfb101d4ecdedb964f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa7f64a3c70cb7e97d4fa4be2e2ddbb9ca7a28b0f39dbcfb101d4ecdedb964f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aa7f64a3c70cb7e97d4fa4be2e2ddbb9ca7a28b0f39dbcfb101d4ecdedb964f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "72718b49ee0d98a23629e5f3e74de3faa9aa14bd2bb3940d4db28ffa3c887f65"
    sha256 cellar: :any_skip_relocation, ventura:       "72718b49ee0d98a23629e5f3e74de3faa9aa14bd2bb3940d4db28ffa3c887f65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1445be5558d2e52ddf9b0565f641a07d747c096c35b1389049cc0f606dfab16c"
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
