class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://github.com/juju/juju.git",
      tag:      "juju-2.9.17",
      revision: "a03f87273065bed590ee54b977eca87a6b323280"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git"

  livecheck do
    url :stable
    regex(/^juju[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c625f730908972eab4c6bb0ef94b5df32e99c00fe579217f1a8410fecb437491"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "488790b4c784ddd3937a0b081f6e5e7c431b13824aaeb897ca667877c32faaea"
    sha256 cellar: :any_skip_relocation, monterey:       "ec047db66e9c39cd71f0f5592396104a0cb15dae8dfb52ea6cfda84c5020f39d"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ec0328625b55c1f6617a070a57ac2b21c87ce3d285486458e6aff541109b1af"
    sha256 cellar: :any_skip_relocation, catalina:       "7df94ba4cd676d09967c4809c603723b80a5b8c796132736a7a335af283658da"
    sha256 cellar: :any_skip_relocation, mojave:         "020fa17eb67e6bf18fdc37c0fa42aae456c7ef4afb147063a6d5c82da4920659"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a5e8a994802ce99d201ebaf5e24cd0f1f05fadd87a6d3037c679785e0dd654a"
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
