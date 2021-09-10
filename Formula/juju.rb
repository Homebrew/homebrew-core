class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://github.com/juju/juju.git",
      tag:      "juju-2.9.12",
      revision: "86d7f5193303a307171fba4cea7745b326023282"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git"

  livecheck do
    url :stable
    regex(/^juju[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9be895775735d87302e7707f491b8e7d9ef4b92009ccd576f9356a906550c4de"
    sha256 cellar: :any_skip_relocation, big_sur:       "10ae9cb9022a8c796813b125cbbc18ded4b9fc07b3da1e033bfc29f8a4a0ba82"
    sha256 cellar: :any_skip_relocation, catalina:      "de22196e060987754bac731ec6974212fe015e0b2fdf5146e32904cc75127036"
    sha256 cellar: :any_skip_relocation, mojave:        "26aa0e7b76ed91f2513d488ad01b8c70e86ac0d7ef355c99e7538d966c785b57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "753fdef07406dece98db190dfdb59ffac91ef321278ded928b652d220f4f6ae6"
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
