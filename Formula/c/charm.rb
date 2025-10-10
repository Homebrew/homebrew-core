class Charm < Formula
  desc "Tool for managing Juju Charms"
  homepage "https://github.com/juju/charmstore-client"
  url "https://github.com/juju/charmstore-client/archive/refs/tags/v2.5.2.tar.gz"
  sha256 "3dd52c9a463bc09bedb3a07eb0977711aec77611b9c0d7f40cd366a66aa2ca03"
  license "GPL-3.0-only"
  head "https://github.com/juju/charmstore-client.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23c05ff713871756c9636e01d7de20645150e6180d9426f8fe33a3f4ff0e6885"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2ddeaf1bab0b233267484c6bdac331a9113af93d5819e6f48ef7642b4696dc1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2ddeaf1bab0b233267484c6bdac331a9113af93d5819e6f48ef7642b4696dc1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e2ddeaf1bab0b233267484c6bdac331a9113af93d5819e6f48ef7642b4696dc1"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a50613b56ac6dbd9bd7c8def6f03899188f3a4a0992098e75e6d49493b4cd19"
    sha256 cellar: :any_skip_relocation, ventura:       "4a50613b56ac6dbd9bd7c8def6f03899188f3a4a0992098e75e6d49493b4cd19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60e259f6541281a54f94e6b9dea178bacc9d348330e7b781441995f35e97eb73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "393502f468997806b663a548026487a0cc7bdceec9bfce3bfa6cccba45551d59"
  end

  depends_on "breezy" => :build
  depends_on "go" => :build

  def install
    # Charm requires bzr (bazaar vcs) for fetching launchpad.net/lpad Go module.
    ENV["GOVCS"] = "launchpad.net:bzr"
    system "go", "build", *std_go_args, "./cmd/charm"
  end

  test do
    assert_match "show-plan           - show plan details", shell_output("#{bin}/charm 2>&1")

    assert_match "ERROR missing plan url", shell_output("#{bin}/charm show-plan 2>&1", 2)
  end
end
