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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfaf4c5b6fc7bbae376894ff75504f7a171254589e9c510737d24719c21a9a97"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d80d9eaa233a231a6886aea27cdf70e1f80f226515cdeb82d400cbdb5e35e458"
    sha256 cellar: :any_skip_relocation, monterey:       "08dc76158581189fd87f055faefe0e4af9ebc2380d5b293b5354027cc86ffd0c"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa7701fb35eee3b99b71a2c409fb106a018c80e1e74480c1f027da1b42116d84"
    sha256 cellar: :any_skip_relocation, catalina:       "dd09292e07ffaf4c813e4688d81427573b923c8be85b694bf6adfa9688d15275"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "577c47afd0f9a0c7895725325fd0246ed9f1b45e5804257ded1472b01dceabeb"
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
