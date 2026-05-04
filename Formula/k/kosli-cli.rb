class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.17.5.tar.gz"
  sha256 "2867b97d26e873145a066a0037c24afb2fd1f01684eed25a836907719e922e65"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d602880d2db43e7dba7111ce5865ca10a36896271445f229246c59d5137bbec7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec055c9a50d2cf69339274c5fd84c236f96e035f100bfaa7ede81066bd0407e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96a64d7b0bcb1896f5c151966edfbded5c78b492a82aa2d5ca839264515c9a32"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e526e0e109936379201e89f716982b43de8d2be9588039ebdbb900fa4b951ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39cc6c1d539307a705bae0b7ae70a988dd7d251aa355c5ccae9d50b8585eed37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4310d5e24fab248b13929d5a45a650b3604dcb451776808dcd876bab7640a6e"
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

    generate_completions_from_executable(bin/"kosli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end
