class Pvetui < Formula
  desc "Terminal UI for Proxmox VE"
  homepage "https://github.com/devnullvoid/pvetui"
  url "https://github.com/devnullvoid/pvetui/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "2b853bc9c8681f1d6a143b0bfaca63b835fb2885c0ccfc1b6488fcd0346e5e47"
  license "MIT"
  head "https://github.com/devnullvoid/pvetui.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "849b2f06b57b55d1d123d0a3977ded2e07c3035fdf47fc24a9fe02ff1a047385"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "849b2f06b57b55d1d123d0a3977ded2e07c3035fdf47fc24a9fe02ff1a047385"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "849b2f06b57b55d1d123d0a3977ded2e07c3035fdf47fc24a9fe02ff1a047385"
    sha256 cellar: :any_skip_relocation, sonoma:        "b225f358bc2367c258a312098aea5394611c14bfb0446125f29579fb3d1d323f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fdc3ad68f116487e85de1107df5616ea94807c254598194b9ddb32738996bd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "790f208b29aae9e9c45392f78a45c13f195b607d5d89dfba19650cc6678dfbc2"
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
