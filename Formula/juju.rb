class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://github.com/juju/juju.git",
      tag:      "juju-2.9.10",
      revision: "75aac44fe3d4df90df48baa0b5615d9d9fc1f3ee"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git"

  livecheck do
    url :stable
    regex(/^juju[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7dbb815511ca9beaac6f325c2a7adfeb5a43d3ad86227d572c4a20ea3757a232"
    sha256 cellar: :any_skip_relocation, big_sur:       "d2a31dc2d3cf85b30beb23d40c0886f11e3a5bc8bf7e0c217c44a7d2e216b2b6"
    sha256 cellar: :any_skip_relocation, catalina:      "42a2f8416dfbfb05626fb9f14b73d23cdc3ec020f92411a0b6a5a6119644ec87"
    sha256 cellar: :any_skip_relocation, mojave:        "d885027147c758dcd56c948f5aa7191009f2842d6bbbdee3d2217d8444ec321c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a6d5e9bb71e1686bc82d232df3836846a539ea27e6588fdbc8b1da53eb23d8a"
  end

  depends_on "go" => :build

  def install
    ld_flags = %W[
      -s -w
      -X version.GitCommit=#{Utils.git_head}
      -X version.GitTreeState=clean
    ]
    system "go", "build", *std_go_args,
                 "-ldflags", ld_flags.join(" "),
                 "./cmd/juju"
    system "go", "build", *std_go_args,
                 "-ldflags", ld_flags.join(" "),
                 "-o", bin/"juju-metadata",
                 "./cmd/plugins/juju-metadata"
    bash_completion.install "etc/bash_completion.d/juju"
  end

  test do
    system "#{bin}/juju", "version"
    assert_match "No controllers registered", shell_output("#{bin}/juju list-users 2>&1", 1)
    assert_match "No controllers registered", shell_output("#{bin}/juju-metadata list-images 2>&1", 2)
  end
end
