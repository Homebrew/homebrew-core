class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://github.com/juju/juju.git",
      tag:      "juju-2.9.11",
      revision: "7fcbdb3115b295c1610287d0db7323dfa72e8f21"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git"

  livecheck do
    url :stable
    regex(/^juju[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f37627da1b14df6bec24f7e337cf4eaecd9400599dc86411b23ba3e875d0e0fa"
    sha256 cellar: :any_skip_relocation, big_sur:       "17f285f4bc7311f1321cb054145f4c13035bdcc0dd37a481ff1d937fd6a4e6d5"
    sha256 cellar: :any_skip_relocation, catalina:      "2aa4893d14018ea1b8458a11f303b137554027f44810fb06dfc4d70887a22a7b"
    sha256 cellar: :any_skip_relocation, mojave:        "b54b17f4f1c49dfb121f31c4c21d294936577ccfb6787ef62756abecb3545c75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06b78ba8599420af0bf1e92baa86cdc68d9479dc126251a5d4078334fc5c3876"
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
