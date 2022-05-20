class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://github.com/juju/juju.git",
      tag:      "juju-2.9.30",
      revision: "a461c98909458b689b373b45cf1433a067c34661"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^juju[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ddf55bff5fad015ea3796393142a88f5cbfcedfdbdcffefb654526b083473c8a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bfb8b03fc5a54bb2f6d1677b2f16c1ce98ae7b08620e19a6648ae7cddbd2f8c4"
    sha256 cellar: :any_skip_relocation, monterey:       "a48e091d0d7d5457303e236a52892e3fdf063eedc03bdf8792dac253e6bb94a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "0210f78de4c995e5aa493cebde94557b0ab4f9c72db0b8a836d29723fe51a4e5"
    sha256 cellar: :any_skip_relocation, catalina:       "3eb4ebaa8b5ccff85ad3b7c25e71b7b4944fb6f2481ec491b2da07522587b583"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dae06dfc1ccd98304e6bf86a98802d0abda299fea944c100ac4dc197600be880"
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
