class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://cadence-lang.org/"
  url "https://github.com/onflow/cadence/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "f7ea4f71a102f504e8be3885b8ae846c853480ac02f435549a1e0a7e854c3eb7"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57e24eb074d1f9ce78f2c78d93ffb71d0763f5c95897e3872865168cff41d534"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57e24eb074d1f9ce78f2c78d93ffb71d0763f5c95897e3872865168cff41d534"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57e24eb074d1f9ce78f2c78d93ffb71d0763f5c95897e3872865168cff41d534"
    sha256 cellar: :any_skip_relocation, sonoma:        "16956bc4f4191c85c43713ba1d5d01234a9b3ffb2e1172aa2452195ee18e3b1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f401316af27519679415f3bb15752d6b3a127818c3f3c4d277ff2f19cd0d3737"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90f033626a4f4b9f893494c921a4883437178b261ffd825ec888215279734e8d"
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
