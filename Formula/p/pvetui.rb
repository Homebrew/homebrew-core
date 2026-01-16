class Pvetui < Formula
  desc "Terminal UI for Proxmox VE"
  homepage "https://github.com/devnullvoid/pvetui"
  url "https://github.com/devnullvoid/pvetui/archive/refs/tags/v1.0.16.tar.gz"
  sha256 "33e3af93fbcee6a6fe8687158c97b0a3f43a3bfd3831cb92d3efc63382f17de7"
  license "MIT"
  head "https://github.com/devnullvoid/pvetui.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06767dc5ab59cb25d7bb63e892a9c73ea06c85e2ab5d43a379e64307b99d2949"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06767dc5ab59cb25d7bb63e892a9c73ea06c85e2ab5d43a379e64307b99d2949"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06767dc5ab59cb25d7bb63e892a9c73ea06c85e2ab5d43a379e64307b99d2949"
    sha256 cellar: :any_skip_relocation, sonoma:        "13bf96f92bb12d269f2a7a19bb419289d53dc97bf415463484cc05a4cebdf294"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0d04c266726b351daa3aae9fe4d86ef6bfbc0f341341876bf988f13be7dbf4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45cdd7ac87335364b9d722aa19e52b1992dab7f8b7fe559b358296b46f921509"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/devnullvoid/pvetui/internal/version.version=#{version}
      -X github.com/devnullvoid/pvetui/internal/version.commit=#{tap.user}
      -X github.com/devnullvoid/pvetui/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pvetui"
  end

  test do
    assert_match "It looks like this is your first time running pvetui.", pipe_output(bin/"pvetui", "n")
    assert_match version.to_s, shell_output("#{bin}/pvetui --version")
  end
end
