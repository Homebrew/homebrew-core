class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://github.com/juju/juju.git",
      tag:      "juju-2.9.22",
      revision: "07164c4b2c6a9f5b576b1c151bd85dd3a699be16"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git"

  livecheck do
    url :stable
    regex(/^juju[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2ce7c4e455db58eb8ad8642f4a5359beb652c3bb948ba06953f9cdebcad6737"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a9c1ef5277e374b8bd1b93eb9f39ebe901aafd4a4bbf3a8b461f0c912a94f58"
    sha256 cellar: :any_skip_relocation, monterey:       "b149c05d34d0c0165e23713d9af8e960a9dd24929de8512d108bf4e0cd6dc778"
    sha256 cellar: :any_skip_relocation, big_sur:        "031f51dd43a1fef61e7cb886ea03b7f652bc5e99df1cde34487fc1c269ec3955"
    sha256 cellar: :any_skip_relocation, catalina:       "99ccc4ebb11525c9ddb052aa6bfb8a2602a459f5fd67f43c08344f356697f1d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e276319fbc2afca9abc096af7b60a2b72c191371ab8a99294178db522b0266d5"
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
