class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  # https://github.com/Homebrew/homebrew-core/pull/57456#issuecomment-656703975
  url "https://github.com/juju/juju.git",
    :tag      => "juju-2.8.1",
    :revision => "16439b3d1c528b7a0e019a16c2122ccfcf6aa41f"
  license "AGPL-3.0"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ef720ba46c646b4f253d853025b4b9648fd289359728b33cbef7861fb57bc4ff" => :catalina
    sha256 "25c4bf277b5b80b48228503c965b996a35a2746ba5b87330cc0d574734cfe8db" => :mojave
    sha256 "5cdb370bacf131d6e1a5de065cf7055566a3f75e58afc5344fe0598915f3a638" => :high_sierra
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
