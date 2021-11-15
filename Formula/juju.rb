class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://github.com/juju/juju.git",
      tag:      "juju-2.9.18",
      revision: "3c1888c8d9e0bdce1d4f9245521e415119393920"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git"

  livecheck do
    url :stable
    regex(/^juju[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bd1a83610ba370eadfcc87cdd3561d500636db2bc77158a562f3872f8c4133b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4557ac99c75773cb8f63b4297f99dcb86822da81656836dac83ca97b8e2967bb"
    sha256 cellar: :any_skip_relocation, monterey:       "0eefffc846aba0d513efe95b2565f9fb299d2031127f73448441f41573eaaab6"
    sha256 cellar: :any_skip_relocation, big_sur:        "52534f07316024680db54abd976668c1ef220c6fb0eed99a1a96ae4dc38b0a53"
    sha256 cellar: :any_skip_relocation, catalina:       "4065f8c18b2dfd0d4cc4b5aec18c4452a8c06ae9d46bd9c8919349ac3d34d8e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79b92ebbfc8d42d9e700e28d6b8aef69318502cb4d15bcde4eee7ee51287da2c"
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
