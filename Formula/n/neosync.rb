class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.3.64.tar.gz"
  sha256 "fe922cb49965b70faa84027aa57dc30727afb4207e6beabda655e2b18eaecfc1"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf2ce9008d0c514525b812f91596a6ffabe09120542261021a6ecc76e4da78c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47c04a96c2cb3363d35f6ee5c662c88c7d41cffa660d93d035210a97b1796955"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1178da67cbd0b3f9b926f8b00cdbcd6452fc0f61a9854dcb3f4d34f4b14cf75"
    sha256 cellar: :any_skip_relocation, sonoma:         "9685f8d986e3f7779d405fd839eb96fdc7de97b3895eb0867c4a96485776df27"
    sha256 cellar: :any_skip_relocation, ventura:        "b3fb21bfd35dd6c373c9295e60ff5ffc3bb0f4f1668684b23727902c6980d9b0"
    sha256 cellar: :any_skip_relocation, monterey:       "62938e92c9b150cff7ef867ff7c56e456bec19c7288e97236f4053db50658d52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6fbf3d562dbe4d2d7aebe0869e72646b528625ed7d2072126dc3935f4bdde25"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitVersion=#{version}
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/nucleuscloud/neosync/cli/internal/version.buildDate=#{time.iso8601}
    ]
    cd "cli" do
      system "go", "build", *std_go_args(ldflags:), "./cmd/neosync"
    end

    generate_completions_from_executable(bin/"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}/neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/neosync --version")
  end
end
