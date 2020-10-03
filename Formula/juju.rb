class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://github.com/juju/juju.git",
    tag:      "juju-2.8.3",
    revision: "ab69570b38fbc746e54184e4c3274612bcbb8327"
  license "AGPL-3.0"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^juju[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ede2c6d02b753c3ae489bee462866874551e604a231ad97eb104849f49c950ef" => :catalina
    sha256 "d819e9291de4c4ecfc04a0fbc20bbd7fbe91f0d96b2c9a03de83383d485ffdca" => :mojave
    sha256 "d6cb117d7669062cae68a37db22febbb7d309df2581c788d5b8ed8c126b689db" => :high_sierra
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
