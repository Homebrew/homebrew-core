class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      tag:      "v3.18.3",
      revision: "528c58600dcb1ab40eaf99135c8113fc049514dd"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calicoctl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1fe83a4bd70f1c40076d642cc6a6083e26cb2c0f83842c12f26792ada6f7d27d"
    sha256 cellar: :any_skip_relocation, big_sur:       "7ac2484cc4e84f7433ea0cba53c96b96d28896f47ced7c306de8976f024a4dcc"
    sha256 cellar: :any_skip_relocation, catalina:      "93a4a48b02c8164df58f4e4e04f94c01edb8e6133bf4f7c53281e91fb1467a7e"
    sha256 cellar: :any_skip_relocation, mojave:        "4fe31a97a3bc06f615c2ac51730d304655631a511af50a84c95bee60c646bd4b"
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
