class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.33.3.tar.gz"
  sha256 "8e55b89491619be461632382d85ce01ab66a66b6dbb022c1aa7ef0fd78acbe8a"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fe334dd8a62f7ec6dc84fb98e365248e7825a639f732920ddf7edac85a915e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5dea5463211db1707f0cb7ea170f879f3befb0b1dec03ccc5e5478464f7a06b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ac44f2249207888ac22c44aa40d33d7d6cade738db4129e05d8693a26065885"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ca0e11be8729ff4719b9f38a54776a0978192e50b4553584020ddcc6d37c9fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1edfd8b433d73ea9a7881e0eeb983d79e3436764b07771d1f806417736fb465"
    sha256 cellar: :any,                 x86_64_linux:  "903a66ca72484c91339e815449eeac4c9249887201a38a2cc41bdb3d152d2d89"
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
