class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://cadence-lang.org/"
  url "https://github.com/onflow/cadence/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "3768c6fa9547b644ccefa584b976ac59f5674988abf0256a26ea9536a8dec1b3"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e2a846f337a82f3fbf3822a0950945c7c7c444c82019f263f60df0442be9dd6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e2a846f337a82f3fbf3822a0950945c7c7c444c82019f263f60df0442be9dd6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e2a846f337a82f3fbf3822a0950945c7c7c444c82019f263f60df0442be9dd6"
    sha256 cellar: :any_skip_relocation, sonoma:        "7817539f10107ea044ee4662609224b300b5928805ec6b21f289c179a3185e16"
    sha256 cellar: :any_skip_relocation, ventura:       "7817539f10107ea044ee4662609224b300b5928805ec6b21f289c179a3185e16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acc6402072cbc6b163606e02d6ebb4c5f535285dfa59d2b3c22699230be7f47b"
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
