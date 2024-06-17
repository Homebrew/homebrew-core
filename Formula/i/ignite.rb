class Ignite < Formula
  desc "Build, launch, and maintain any crypto application with Ignite CLI"
  homepage "https://github.com/ignite/cli"
  url "https://github.com/ignite/cli/archive/refs/tags/v28.4.0.tar.gz"
  sha256 "cbd4a26bd4889ad10a6f7161ca7e5c4e9cc037105d8f31e691d8a9ed394c4ed8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7f9fb56a4dadc569917e8d095a752397b6a2f13856d143cb60680fbc96f794a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94aaac8d8c0ec0e7efae22ec552846cacd12bceb573e373511c60ff5d5c80b68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b578a5ce70ce4c4d6a1e38c33b44837f0b9dfd32d48aebfe24300388e50badde"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd8c26801e540a46d7def4a5527145646d48f131a1087a6312e4c0f3ca38502c"
    sha256 cellar: :any_skip_relocation, ventura:        "2e9c848bcaa459da22d78cbce718052ec3890111d770813657385dd76a0b80b3"
    sha256 cellar: :any_skip_relocation, monterey:       "5da05279a26e366a3f278e290719b5cc3f35d067e0b4c942ad8551d0260abe35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "774391f595478ef18f87ec764818f93e1a1e3d1c43ab721f980594d98004467d"
  end

  depends_on "go"
  depends_on "node"

  def install
    system "go", "build", "-mod=readonly", *std_go_args(output: bin/"ignite"), "./ignite/cmd/ignite"
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    system bin/"ignite", "s", "chain", "mars"
    sleep 2
    assert_predicate testpath/"mars/go.mod", :exist?
  end
end
