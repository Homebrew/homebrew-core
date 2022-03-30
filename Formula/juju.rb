class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://github.com/juju/juju.git",
      tag:      "juju-2.9.28",
      revision: "e1ee28cc50e53fc4553187e7ef805510b0da70a7"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^juju[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7742dd2d4b869539c476e2c17503735dabc5c7f928977efb351e9991866ac750"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70d98a2819a978d79d32d07d8623abf36a321e515b594651730645acf84c0cf8"
    sha256 cellar: :any_skip_relocation, monterey:       "ece121f0238d81b412a05e3deab5dcfea5269cd9c623a90f6f74019a75d4c677"
    sha256 cellar: :any_skip_relocation, big_sur:        "c5adfe03e81f17de6db4b56de349223b23aed1ef3cb3de3aaa0fc4e97f460224"
    sha256 cellar: :any_skip_relocation, catalina:       "2bbb10bc03c41ca88ccfb79b11448d08bd2123586e6f37a43867f185443f3cc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e99d9509c5348ba24f792b15f17b5628186d2c292bca9b8d0d39589c12df28d"
  end

  depends_on "go" => :build

  def install
    ld_flags = %W[
      -s -w
      -X version.GitCommit=#{Utils.git_head}
      -X version.GitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags: ld_flags), "./cmd/juju"
    system "go", "build", *std_go_args(output: bin/"juju-metadata", ldflags: ld_flags), "./cmd/plugins/juju-metadata"
    bash_completion.install "etc/bash_completion.d/juju"
  end

  test do
    system "#{bin}/juju", "version"
    assert_match "No controllers registered", shell_output("#{bin}/juju list-users 2>&1", 1)
    assert_match "No controllers registered", shell_output("#{bin}/juju-metadata list-images 2>&1", 2)
  end
end
