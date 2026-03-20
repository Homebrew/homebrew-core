class Gtree < Formula
  desc "Generate directory trees and directories using Markdown or programmatically"
  homepage "https://ddddddo.github.io/gtree/"
  url "https://github.com/ddddddO/gtree/archive/refs/tags/v1.13.5.tar.gz"
  sha256 "f661a1ad7b447128a122eebd1d602839ec00d1e39eb66e3224abc95d79a1ebf2"
  license "BSD-2-Clause"
  head "https://github.com/ddddddO/gtree.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69bbf66c6d8c4811d8a4134aaf25230f1ffeeb07b97f004f852851451a08ccbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69bbf66c6d8c4811d8a4134aaf25230f1ffeeb07b97f004f852851451a08ccbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69bbf66c6d8c4811d8a4134aaf25230f1ffeeb07b97f004f852851451a08ccbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "72d47fa901ac3749f0a3b4a20a561a2e94beda1d08dd8e9e7cb0c3830047d27a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5814cf19102645550b570ee7f180898bbd3123da97306e032163484e33e4450c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10046444756484015a2b2a55f236c772e4047a46d918b1f6e6de39257cf97dec"
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
