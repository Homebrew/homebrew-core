class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://ubuntu.com/lxd"
  url "https://github.com/canonical/lxd/releases/download/lxd-6.2/lxd-6.2.tar.gz"
  sha256 "44f98776b9e9e1d720da89b520d75bf8b7c3467507b2d24ada207a160ec961f3"
  license "AGPL-3.0-only"
  head "https://github.com/canonical/lxd.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c34c134ebc906cb32b382fd05c246a7158901cf4c9bebc23d52bec45b7b6def0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c34c134ebc906cb32b382fd05c246a7158901cf4c9bebc23d52bec45b7b6def0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c34c134ebc906cb32b382fd05c246a7158901cf4c9bebc23d52bec45b7b6def0"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b56f98a046cb2532c939d3cf390ee1953544ceed361437a180cafb11bdb0d9f"
    sha256 cellar: :any_skip_relocation, ventura:       "9b56f98a046cb2532c939d3cf390ee1953544ceed361437a180cafb11bdb0d9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f303552a55818faf6627e9d0c5cad21b80489e748414ef4cfb7aec49feecf06"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./lxc"

    generate_completions_from_executable(bin/"lxc", "completion")
  end

  test do
    output = JSON.parse(shell_output("#{bin}/lxc remote list --format json"))
    assert_equal "https://cloud-images.ubuntu.com/releases/", output["ubuntu"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}/lxc --version")
  end
end
