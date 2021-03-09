class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://github.com/juju/juju.git",
      tag:      "juju-2.8.9",
      revision: "a48bedf0ae2096d0cf750b7676da9b0a994cff09"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git"

  livecheck do
    url :stable
    regex(/^juju[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "95dc859c88bb9d6dbbb70a2d20bc9c899e84751f1a053b4f837a1dd6c38f5464"
    sha256 cellar: :any_skip_relocation, big_sur:       "06e8634a1b1b7fd5e532df6a7251ce9fd25ce63b74b9f6f45eeca53e005c3860"
    sha256 cellar: :any_skip_relocation, catalina:      "fb58675cb2a2c8f3fa5998573f602b482e1197be7f4ce1d2248eefe8b8280bf4"
    sha256 cellar: :any_skip_relocation, mojave:        "cffd1836e51caa82e3e8a98be443c9ba30b7e0a80e6a3262f6b5bf4bc0c2b4d2"
  end

  depends_on "go" => :build

  def install
    ld_flags = %W[
      -s -w
      -X version.GitCommit=#{Utils.git_head}
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
