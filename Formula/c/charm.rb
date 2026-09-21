class Charm < Formula
  desc "Tool for managing Juju Charms"
  homepage "https://github.com/juju/charmstore-client"
  url "https://github.com/juju/charmstore-client/archive/refs/tags/v2.5.2.tar.gz"
  sha256 "3dd52c9a463bc09bedb3a07eb0977711aec77611b9c0d7f40cd366a66aa2ca03"
  license "GPL-3.0-only"
  head "https://github.com/juju/charmstore-client.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b9a5df58877af8e3ad37c3385f8d2e8135cd35f080a446fe279678999a7b1927"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b9a5df58877af8e3ad37c3385f8d2e8135cd35f080a446fe279678999a7b1927"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b9a5df58877af8e3ad37c3385f8d2e8135cd35f080a446fe279678999a7b1927"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4137ad2f14ddf96d8bb87dafbcda64549f130b491c07b749f1a8751261578a0e"
    sha256 cellar: :any,                 x86_64_linux:      "cf2a6ab1ae2fe665374bdf5f22f2a0e16071f6862cce316370a8293f4ff79c4a"
  end

  depends_on "breezy" => :build
  # Go 1.27 dropped bzr support: https://github.com/golang/go/issues/78090
  depends_on "go@1.26" => :build

  deny_network_access!

  def fetch
    # Charm requires bzr (bazaar vcs) for fetching launchpad.net/lpad Go module.
    ENV["GOVCS"] = "launchpad.net:bzr"
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/charm"
  end

  test do
    assert_match "show-plan           - show plan details", shell_output("#{bin}/charm 2>&1")

    assert_match "ERROR missing plan url", shell_output("#{bin}/charm show-plan 2>&1", 2)
  end
end
