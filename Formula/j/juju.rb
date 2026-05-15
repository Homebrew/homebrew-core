class Juju < Formula
  desc "DevOps management tool"
  homepage "https://canonical.com/juju"
  url "https://github.com/juju/juju/archive/refs/tags/v4.0.10.tar.gz"
  sha256 "78909815d2b60bd61d40b8bf4eb4582bfaf83c7ede95baf92ec94fe466323c5f"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "abc969bd104ca60e43323cad926de041e144a3dd1418aa0dbc2c1e58c415269a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5952e333289a04511be819d84138256168b5e1218dec81b109b7c8a27c751d2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a09efc7813b98ee78ab80b71781d8349bda598a7442dcf63b752487d57067045"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba6bdc84f260ebf890b21a28380a427bf4163c978c2a704e53c4c672460b6bb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1aeee435b4043cc706b88e72bf92537bf6a3bd30e3a3cd273c84acb0794c5ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61518815981435c850ce62e87db413bef0b69a3b6e431d6dfc50fb115d113b40"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/juju"
    system "go", "build", *std_go_args(output: bin/"juju-metadata", ldflags: "-s -w"), "./cmd/plugins/juju-metadata"
    bash_completion.install "etc/bash_completion.d/juju"
  end

  test do
    system bin/"juju", "version"
    assert_match "No controllers registered", shell_output("#{bin}/juju list-users 2>&1", 1)
    assert_match "No controllers registered", shell_output("#{bin}/juju-metadata list-images 2>&1", 2)
  end
end
