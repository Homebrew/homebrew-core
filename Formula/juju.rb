class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://github.com/juju/juju.git",
      tag:      "juju-2.8.7",
      revision: "ee2cfeb2c8c716af763a011e184ddea879c0985d"
  license "AGPL-3.0-only"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^juju[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "5aaabdd93f04979ca322804b7e5f748eca3d725b4e7e0edd9bbbfde555a374ef" => :big_sur
    sha256 "81166cd79c3370366659e16fb9e3dac22319be350225654d302659dd54a4dcf5" => :catalina
    sha256 "3a49f2c755bb81a4625dca0f41172eaf367b8a41e8bc943f021112c07894cffb" => :mojave
  end

  depends_on "go" => :build

  def install
    git_commit = Utils.safe_popen_read("git", "rev-parse", "HEAD").chomp
    ld_flags = %W[
      -s -w
      -X version.GitCommit=#{git_commit}
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
