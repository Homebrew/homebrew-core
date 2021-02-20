class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://github.com/juju/juju.git",
      tag:      "juju-2.8.8",
      revision: "1d2677ae1d65f10bd15e9e29ab5e0f0cca70898a"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git"

  livecheck do
    url :stable
    regex(/^juju[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "67ccc3baca4e7d4546c80f3ed22272a4d5cefad57d1755bdab4d54d36916a862"
    sha256 cellar: :any_skip_relocation, big_sur:       "f3acd40ef4b5822f2aa84893383d1d4c6459eee98fd8889ab262d78fe88f9f04"
    sha256 cellar: :any_skip_relocation, catalina:      "26065d4e5b2dbe5e74f295a9d6bb458102422bd2f05fb89ceaf2b5de8f085f02"
    sha256 cellar: :any_skip_relocation, mojave:        "3ee10ae581a92d8a6c687d03eb7c09b8458e3585692fe5c81b3b5bfbc30bfa50"
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
