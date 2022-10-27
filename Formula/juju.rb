class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://github.com/juju/juju.git",
      tag:      "juju-3.0.0",
      revision: "35c560704ee254219ae0c4a37810bde5278e99bb"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^juju[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3798628817ff4cd981f515a119e45cda856a0555cf4483e9280bd9a757514bf4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93ef7cdd793213a293c4dadfc5753a443ddd7915420ac33dc0795a276e30a604"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "684680aaca74b6234f48618b473b50c1af075d5f67417d4f1529fa2d2822670f"
    sha256 cellar: :any_skip_relocation, monterey:       "fd1586025d1214f96ad28baed21a162f03fc2146fb9ca7e0c3ba1dc55c527c17"
    sha256 cellar: :any_skip_relocation, big_sur:        "430db3604ec4719b90671db00a2cf0dbffd531b199ba771dfc367f1264d332f9"
    sha256 cellar: :any_skip_relocation, catalina:       "39de5848c69a2ab993d58b046ae603a5d3ecb99915cb83986280774a90edde36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fde66c0a1e317cf078f6c9f625b75b3bec5e700b11efba6c516f7ac7ca3bd888"
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
