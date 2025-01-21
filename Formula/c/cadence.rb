class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://cadence-lang.org/"
  url "https://github.com/onflow/cadence/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "05ba5fb56609640b38555c06dda8722e6a76a23f99862696cf6312693884fdcd"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f81d58fc5c851163b6efb610b571c2cc583f938bbdbf994ab940be8fd5ee87b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f81d58fc5c851163b6efb610b571c2cc583f938bbdbf994ab940be8fd5ee87b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f81d58fc5c851163b6efb610b571c2cc583f938bbdbf994ab940be8fd5ee87b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "05e4df422f3764d2664a1dbf305a0311093892af285653fcf8119f9181b7c362"
    sha256 cellar: :any_skip_relocation, ventura:       "05e4df422f3764d2664a1dbf305a0311093892af285653fcf8119f9181b7c362"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "498b75e2178e74a64f4f944f98655b9cf411e930516e021d755d4714f607b423"
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
