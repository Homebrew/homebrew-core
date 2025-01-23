class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.11.5.tar.gz"
  sha256 "d922d5a1cb060fc6550b81015c47e89465d9414a8eb035068b91b48a70709ba4"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6248dcd364de461823078c7c39028c01f74609831ed0e84feb56713c61816778"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6654547dfae38c68b9d69944aa45771ac1f0d4c81ddd9171eb334d04e830371"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c039432e54f6ffe54b1bf3e64005031a275754282d82c4159427178284990422"
    sha256 cellar: :any_skip_relocation, sonoma:        "85f4f864dafb48f49965b13d8eb6693179f6677d88d54b9daf6a4a574c346854"
    sha256 cellar: :any_skip_relocation, ventura:       "dd10aeb1354a811a1fd9f51bee361f5c6c47ea055a82dd1ede9dc69bc7765256"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0475bc758892c6db6ce6df746dfef1e1506a792795cb713491a702a95971a299"
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
