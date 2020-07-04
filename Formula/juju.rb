class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://github.com/juju/juju.git",
    :tag      => "juju-2.8.1",
    :revision => "16439b3d1c528b7a0e019a16c2122ccfcf6aa41f"

  bottle do
    cellar :any_skip_relocation
    sha256 "ecc6b26468cd3d3989e08e7336d65bb2ec22e267abe8e26214db4f10518ac1bb" => :catalina
    sha256 "b727f2ede77becd56eae969f5c9d9993ee3c35e1cc28b3e7bc5ecb19ef6b593d" => :mojave
    sha256 "5fa27b607fc8f995d7d4f661973454d0a83d9c9020b57583bb3e2c8dc25b802f" => :high_sierra
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
