class Gtree < Formula
  desc "Generate directory trees and directories using Markdown or programmatically"
  homepage "https://ddddddo.github.io/gtree/"
  url "https://github.com/ddddddO/gtree/archive/refs/tags/v1.14.9.tar.gz"
  sha256 "fbedb935bacd045e67a2d91402fa441da0824ff67941bfb5903a653db817e623"
  license "BSD-2-Clause"
  head "https://github.com/ddddddO/gtree.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf657ac4061ee824d1e261b650ce900b1381b7a8fbab824c7d84eec2876d8a62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf657ac4061ee824d1e261b650ce900b1381b7a8fbab824c7d84eec2876d8a62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf657ac4061ee824d1e261b650ce900b1381b7a8fbab824c7d84eec2876d8a62"
    sha256 cellar: :any_skip_relocation, sonoma:        "051f88324c026087969ee7411b1887a906c3760dea39ca26dd378e53df69cf24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2db7280129a5ade6bfa0b1676904bbd38effe03c787c59e552ac899137b8133a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "649344a16805fc4b1ace32624df9e75ffd7e0a7dab33c6495baff1e53d9fe2f1"
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
