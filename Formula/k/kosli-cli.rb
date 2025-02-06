class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.11.6.tar.gz"
  sha256 "8b9af1c0d259e98c096a65e8741cb1539148d909c2a143e15b93ea85bd473803"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7206a188f61045ebc25de7f3b44f8f409f98488376bfca89c2419f9c3e42cec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6509201d7f909c9651637757fa0968d864f7e3294447b3bd519985ef56e01662"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "803486c3701cffb3e0eef286b29e81469746ca8201ff4ca97f8fb03ef8e34240"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a4ea53840953973dcb3aa9e4565aa32b33a409b0ab80f4a04c7c7867c4856ff"
    sha256 cellar: :any_skip_relocation, ventura:       "087d96a52fe82dafd7fd95e7dd1b86cef6e14887ae61e1f6c13f05f515ff3f5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a312dd53e21656ffe3467112c2513ecfa746d4fca23caa8ea86ba3eb291c370c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end
