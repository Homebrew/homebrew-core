class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://github.com/juju/juju.git",
    tag:      "juju-2.8.1",
    revision: "16439b3d1c528b7a0e019a16c2122ccfcf6aa41f"
  license "AGPL-3.0"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "39604be3054cbc4f8f7ab659e979e05ccb04186cdd500d1ee1ce246ef22b44ee" => :catalina
    sha256 "23ca54a610e458e7895f56b8d0ee4233f6e78357e16d4910bee9e6819a2f0eb5" => :mojave
    sha256 "d90074bf523afaf257b8964b8858980c0f48fd43175a3e3036489dc2a9e60e46" => :high_sierra
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
