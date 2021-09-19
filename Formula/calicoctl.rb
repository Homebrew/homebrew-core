class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      tag:      "v3.20.1",
      revision: "0e555ea2ccc9c2cb5030eab2b43abe97a534f17f"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calicoctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7cd72cdcc599b5d4a27c02f061d900168c415f5ba9b497cef8cadcd34a05349e"
    sha256 cellar: :any_skip_relocation, big_sur:       "70faea851902c44cc5481a4110690c9be2a60465970047b1cc2c9e2dcc274693"
    sha256 cellar: :any_skip_relocation, catalina:      "567cb17f2ba700d9249b7b177f1bc6d0b8720d036b42b0bcd177a094e4fa7595"
    sha256 cellar: :any_skip_relocation, mojave:        "f05b395629be74694da3b3eaf1d348bc92269737e65f2c25b044bafcbb967a5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7db647f55485848d515c0179997fb226654478f061e869e129e8237c8c8b65bf"
  end

  depends_on "go" => :build

  def install
    commands = "github.com/projectcalico/calicoctl/v3/calicoctl/commands"
    ldflags = "-X #{commands}.VERSION=#{version} " \
              "-X #{commands}.GIT_REVISION=#{Utils.git_short_head} " \
              "-s -w"
    system "go", "build", *std_go_args(ldflags: ldflags), "calicoctl/calicoctl.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/calicoctl version", 1)
  end
end
