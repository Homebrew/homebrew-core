class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://github.com/juju/juju.git",
      tag:      "juju-3.1.1",
      revision: "0a2659b7b4f74b0f914e2d150a34724998ddd6c1"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^juju[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21fa811589d1c26a6350b8153c93bcdb4e1ce0f4dd3dfdccfe754da9eb6c377c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f8449ea7f25780e131f3b2cb559b970bbab57df0ec97103962f3003346b2d40"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc8106863cbca607c0a77dc20a8e2276c00b3ede6afc79a14187c4294d40fe08"
    sha256 cellar: :any_skip_relocation, ventura:        "ac115e1ad5d1f206df3cf26af966a0dfcd9381846bfbf79eaf81d90f82636876"
    sha256 cellar: :any_skip_relocation, monterey:       "f2f5abb915c21cac222ea0e16b1d1ab3c0108acf001bf36e990285da3aa5575d"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb256c37847820b0bdc81f053dc71e9f6a7157a7cded4700e8d166557bac9836"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "920443adb51bd358e5d6ca4edb79c049e0982a2ab8615f5c4781f0ff12b65280"
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
