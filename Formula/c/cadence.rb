class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://cadence-lang.org/"
  url "https://github.com/onflow/cadence/archive/refs/tags/v1.9.10.tar.gz"
  sha256 "bedbfe8441104de447a6780df30154f5aff2e218cd8aa6d820ef1f1b41186551"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bcc2d9c5011aeb19e0aa82466d67d81c3a6593d71ce77b8a4fce3c638e542738"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcc2d9c5011aeb19e0aa82466d67d81c3a6593d71ce77b8a4fce3c638e542738"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcc2d9c5011aeb19e0aa82466d67d81c3a6593d71ce77b8a4fce3c638e542738"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0210d259a53ed17aa51a24d2a8b5b3a4841f7b993befb94dbecc46e134dceb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9bcfb20cf6aa001b3235d1703d95467755521d9f0d89a73aa802413c65f2dcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6df45e8ec9acdbea98c8d7e2870239a80c8f80cee4267f5ecfac50b4620f70f9"
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
