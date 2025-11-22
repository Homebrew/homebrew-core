class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://cadence-lang.org/"
  url "https://github.com/onflow/cadence/archive/refs/tags/v1.8.5.tar.gz"
  sha256 "8160d6975a4517cc05ea7986d2cf2854aed4996152f3c0e62bc59febb535a4bb"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28519aff3f4ecbf7ef9212d9ea324c07109f18a07de473c2727be207e9fb885e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28519aff3f4ecbf7ef9212d9ea324c07109f18a07de473c2727be207e9fb885e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28519aff3f4ecbf7ef9212d9ea324c07109f18a07de473c2727be207e9fb885e"
    sha256 cellar: :any_skip_relocation, sonoma:        "3db41596e115c507573f36d0d0d80917f45bd59ba6a955c84e4b7df2918b44e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7624792465e85ff664c3d7bf109441e4a76b4327b095d2e8d93f617aa5249b75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98d73b80766b1318dfa294c2a98cd1450780edaa844564ee046b5348557d210a"
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
