class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.12.4.tar.gz"
  sha256 "97e191b89e415ac3163b8a5e5d9d757a2e01266d67c2d02730852d566b7a1089"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "922e00af9ec1eb5d5d604a45f59068f15eae3e51750f81ce56ed232b3d0fa5ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "922e00af9ec1eb5d5d604a45f59068f15eae3e51750f81ce56ed232b3d0fa5ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "922e00af9ec1eb5d5d604a45f59068f15eae3e51750f81ce56ed232b3d0fa5ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e8a0c30dbdc2d6dd0fdf8bdd493e88cdb66417b95d1c1119a28a73a4336e61d"
    sha256 cellar: :any_skip_relocation, ventura:       "7e8a0c30dbdc2d6dd0fdf8bdd493e88cdb66417b95d1c1119a28a73a4336e61d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcf447c6200c6fec910164b3a6ff17348fbaf49399bbc4fbd8d0a291313e0449"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "no_self_update")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_path_exists testpath/"lefthook.yml"
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
