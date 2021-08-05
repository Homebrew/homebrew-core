class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      tag:      "v3.20.0",
      revision: "38b00edd005363b369dd7c585933b08376f76d6c"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calicoctl.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "677d157528a5909b1458c93d43393963b35d1255d7049f4bf8a8fc04b7570a90"
    sha256 cellar: :any_skip_relocation, big_sur:       "cdbab5ac325eedda71d8202e8f4432d3a102ca58de1a4d2f046ba460b9924928"
    sha256 cellar: :any_skip_relocation, catalina:      "48b3401872ab211cb283e5ef1c3385ee7d354343d72109a196c081e8af419a73"
    sha256 cellar: :any_skip_relocation, mojave:        "9d45eff244ca6865529dcec2bc9d09dc701cf0ba0215cfb8ecef80cb47a80c51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad5e91a5daea68fb2cfe8d7f8e3d8414f60f83502c67f878711fdd3de3b2bbed"
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
