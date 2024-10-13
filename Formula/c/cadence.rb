class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://cadence-lang.org/"
  url "https://github.com/onflow/cadence/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "2a7a9afb2bf984627638e98588f740e87d52f8c16199474b72044f2021d4a236"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05471216abc3b2e141fabcfc3b498617617357c72396d7ff39c2ed41b2a150dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05471216abc3b2e141fabcfc3b498617617357c72396d7ff39c2ed41b2a150dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "05471216abc3b2e141fabcfc3b498617617357c72396d7ff39c2ed41b2a150dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "26813f7793ace1b7b54d5d54579516c6ca4adad4cf296c9a2bb34abd2a89cfbd"
    sha256 cellar: :any_skip_relocation, ventura:       "26813f7793ace1b7b54d5d54579516c6ca4adad4cf296c9a2bb34abd2a89cfbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb4b6a8deb366d63b49b2fb92e371179a6cc5b2d16976acd37927ad4c244a30d"
  end

  depends_on "go" => :build

  conflicts_with "cadence-workflow", because: "both install a `cadence` executable"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./runtime/cmd/main"
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
