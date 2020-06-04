class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://github.com/juju/juju.git",
    :tag      => "juju-2.8.0",
    :revision => "d816abe62fbf6787974e5c4e140818ca08586e44"

  bottle do
    cellar :any_skip_relocation
    sha256 "f5e2dfb9c61ad71bde7cfa9fbea7b332929a7a17bcd9c5572862c6c72ec68ccc" => :catalina
    sha256 "c403a83802d6bd52a3cee90be7ca5235683b5c7fdcf67b0a39905db4a53023e3" => :mojave
    sha256 "d55865d9e9ae6cdd35225a4dba3e869f5380d7b73d9ae02eae4331ba439738d3" => :high_sierra
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
