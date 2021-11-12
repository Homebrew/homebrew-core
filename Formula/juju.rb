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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "233ed0721e3235e85d0c54cd2f72f4de533c3bbb0087a53cc598de648e1d291c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c4fcfe3e56a616915e64645022f536a5bbf0a7286a4f1e0867ef97877f70f7d"
    sha256 cellar: :any_skip_relocation, monterey:       "c5a96d89c3b749d08cc338f513af66b38325380c47efd2d2aa876351bd597442"
    sha256 cellar: :any_skip_relocation, big_sur:        "1bb2c98567e9cab8266c584eb31b91dd1a720081b320b80dd2e8bb408e3deb9f"
    sha256 cellar: :any_skip_relocation, catalina:       "4db9c75f82acc1c4f13d9899c20188d2c9e97d6fe53b36a9854ad9694e6460d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22c94697bb4875df448e48210b3b358ecddcaa3c3c7ed1cc9b06bd5cf574ebf4"
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
