class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://cadence-lang.org/"
  url "https://github.com/onflow/cadence/archive/refs/tags/v1.9.5.tar.gz"
  sha256 "c87e35e24e1ca40e569afcfe1f4a11da77eb91101327540203eed3a71bdbd24a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79f73169c8d2a392e6e8ca173492152f50e01766db4fb70c3c0d24fa342bfc8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79f73169c8d2a392e6e8ca173492152f50e01766db4fb70c3c0d24fa342bfc8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79f73169c8d2a392e6e8ca173492152f50e01766db4fb70c3c0d24fa342bfc8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "21112049c574059a97ff0d36d8ba5f48b746ea8b9accd2c54974ff9703c75ecb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b4f5076761af22f9674658a433b995f64feb41002d42bf9bdb9458b2a9d4b01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01213d1acc311a66fd8e7ff01659fc9f173bf743085d3db65a5dd9407bf8da80"
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
