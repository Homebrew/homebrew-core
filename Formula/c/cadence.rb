class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://cadence-lang.org/"
  url "https://github.com/onflow/cadence/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "7955e8f7715d70f4232d2b6579eed430828019f23cd052be1b18319ba40bae92"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c459a7920f6dcab5d207d2f47d5e60f445e55bbb050dfcda72ff93afa2ff4cf3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c459a7920f6dcab5d207d2f47d5e60f445e55bbb050dfcda72ff93afa2ff4cf3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c459a7920f6dcab5d207d2f47d5e60f445e55bbb050dfcda72ff93afa2ff4cf3"
    sha256 cellar: :any_skip_relocation, sonoma:        "48a0d24aa77f24be66e7a5f516aadfcd1f69317b6dda5b71b80c212b83bb9a7b"
    sha256 cellar: :any_skip_relocation, ventura:       "48a0d24aa77f24be66e7a5f516aadfcd1f69317b6dda5b71b80c212b83bb9a7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecc190fbdebe831acfbd7301d6b7e1e843d0aac15efac959d085ab39f5aad0e4"
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
