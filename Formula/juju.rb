class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://github.com/juju/juju.git",
      tag:      "juju-3.0.2",
      revision: "8bf53dc35b25145ef39051fe4136135a3dd53d5d"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^juju[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7080119ffb41e36f11e42c9645edc231381a7f8f299be375dea8249324f6a9f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1d504a7893af0552007ac3b9fdb8c9380482f6b3b1f43d7f7d1ceca6479ad80"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0dddd35d64a8090b8ac9c51716f0b7af858bcaa6d82291a8513653b749b2047"
    sha256 cellar: :any_skip_relocation, ventura:        "4bdbd30d3b480ac656c70a436f28839ea7f697d856778cdca9c592468106785c"
    sha256 cellar: :any_skip_relocation, monterey:       "66c13349be3a70902a1978a55c276855393231072adb47ac210e04399f1fb761"
    sha256 cellar: :any_skip_relocation, big_sur:        "b37311ebb1a302af60a867036e4b0c82aea57c741123821ee32f3fe07e79fddd"
    sha256 cellar: :any_skip_relocation, catalina:       "4397d949c37e99bec5272ce283b8c406dafe04c13dcea21fc3059d867bd67c1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fbff94f3dab3836594a69f77ce8de90a96659f266b15c41ec7b64bc1eab4312"
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
