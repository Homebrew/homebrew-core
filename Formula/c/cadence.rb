class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://cadence-lang.org/"
  url "https://github.com/onflow/cadence/archive/refs/tags/v1.10.8.tar.gz"
  sha256 "d212426e8f3fd7820495fd7d0710494d44d0b7f90ffa712991afd8a16a294f9c"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "410a4779eeb29bf57f22f33471b8b191f18ba9bebe703ccc60bae19b73a73d1c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "410a4779eeb29bf57f22f33471b8b191f18ba9bebe703ccc60bae19b73a73d1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "410a4779eeb29bf57f22f33471b8b191f18ba9bebe703ccc60bae19b73a73d1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8b3eb974939eb7af35a6e361a3d56c23160415235431c5bcc6c05ae0be49f947"
    sha256 cellar: :any,                 x86_64_linux:      "f245f415d4ab237275b07ed500366080035a6512b8cecc935ce327bc5eb6e6dd"
  end

  depends_on "go" => :build

  conflicts_with "cadence-workflow", because: "both install a `cadence` executable"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
