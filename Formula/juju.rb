class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://github.com/juju/juju.git",
      tag:      "juju-2.9.32",
      revision: "917a8f1033561ce28a73ff81d71da75aec6e0785"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^juju[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c6608b9c1aef65bf3fd0a3ce9ca55e81ea3c0747b7d8bc614102e1f78e0d831"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2db012e8d9466580e2f9b967ffc965b62222afd8dec5bde9fb0bf9c349cbdb4f"
    sha256 cellar: :any_skip_relocation, monterey:       "31a81579c270d5a13abaa1089c38f2660201f6297417a2857694ab6c3b9480a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "275ddea44b67bed082f9f5d4b4facaac3c339b093a2aa2a0b976b2095414ba8e"
    sha256 cellar: :any_skip_relocation, catalina:       "280c0f877af1f21cbd82d716b41c19a5f0ca6da4dbb64fd37d78b673d1dba78b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27abb76760610fde4acc514723435f31c7ec060f00073e566b229a034e131bcb"
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
