class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://github.com/juju/juju.git",
      tag:      "juju-2.9.35",
      revision: "da3416008ea4ce7851a4c967ae191a0044917024"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^juju[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de7c97569e526e5797d35ac76d209107d05d7d9e7d4eae0b8b341b74e92db28e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e90886a0c1ef213f6106ce1f69be680c7eb412f7258ca503cc18d89c0899813"
    sha256 cellar: :any_skip_relocation, monterey:       "c279632bc79252fbd7f2198c3d292b4f1a812c9f0effdeca045314427050b42e"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb4d233bd0ed1de21682ac3a6f3e3d3a57bf52753a74d59ce4fb48b739b4c1ba"
    sha256 cellar: :any_skip_relocation, catalina:       "cf37a6769128f79fbf2571de2b05d931ebce7489a9183ba8948310c46075a03d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c54bb610c21c48092c5033aac4f84559e5f37eed5f90a90af98419a8b7233a88"
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
