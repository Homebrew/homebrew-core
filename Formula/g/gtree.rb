class Gtree < Formula
  desc "Generate directory trees and directories using Markdown or programmatically"
  homepage "https://ddddddo.github.io/gtree/"
  url "https://github.com/ddddddO/gtree/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "6523c8839a1904fc5475194dd4b27ebd1d94b07535d2d568ccffb7af0dfbd2cc"
  license "BSD-2-Clause"
  head "https://github.com/ddddddO/gtree.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f80fa9631a13a77cf6d6c01a1d4f7b79e89e0a16d44ef812d5067971cf30e0c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f80fa9631a13a77cf6d6c01a1d4f7b79e89e0a16d44ef812d5067971cf30e0c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f80fa9631a13a77cf6d6c01a1d4f7b79e89e0a16d44ef812d5067971cf30e0c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "44faaa826cb6c3fbfde2f146e2c11546c9c1b0e89e6a7ed9d004e8a648d8cd55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3832867ec7ef76730eaa0643e9ac5d53b43a025fccad231a515dcfc7e5bfc6cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7c94892c375df811024efd7b94f6268ca25d3ea21f5d7ce1c41aa9e793a4c0e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Revision=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gtree"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gtree version")

    assert_match "testdata", shell_output("#{bin}/gtree template")
  end
end
