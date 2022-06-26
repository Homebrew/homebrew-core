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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d49f93840a7457bd0ff722e7d567be3dd072416c93dd612729fbebbab284f42c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6ad4aa6a8abf662cd8e0a7d5f07786d84bb6d9fc47fda14a3b09d10b99b4bdb"
    sha256 cellar: :any_skip_relocation, monterey:       "4763360264aaa67f9f7fffc4800d04387c1eeda98023697118152ee8cd14f9eb"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9a99ee6585f014dfcd2ee4a2cc6f5ad7c4765820dfff7978b8f2688bbbd68f8"
    sha256 cellar: :any_skip_relocation, catalina:       "daca242ad1b6190b044ec5479c45aaf94023da8166aae140a1a45eeda3632063"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "746e62f2957e27f64b31b147b3b88604e259c432d4c5b1ba0b7890a14096a425"
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
