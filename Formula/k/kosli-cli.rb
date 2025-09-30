class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.11.23.tar.gz"
  sha256 "84a63faf1da4ce3b7821240210e272d46533d22898240787143c531a9490394e"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bba26c7ef31b1004ba2861aa9d5455d833ff079493d1e02b719d63c479107dcc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a9888a3daf3280934b6f5f2d913e7ba327a56f3891f2b7b62a8e691c99cd986"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ee802ffc989c8e2f346779d7bdedceedc04b23eccf4cf07e2ba60a820cbd94f"
    sha256 cellar: :any_skip_relocation, sonoma:        "01da8ce765ce833680af9d8bb6fb8523d06c982d1875d101381a64d336c50801"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53a57985e4d55923878756f1f5b2197e6892d84109ebed10d734e29631e45e9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00a18c6add575036ae8bfe3b20b2288eafcb72d63c36027ceee33d36552af32c"
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
