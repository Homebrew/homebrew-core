class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "b554785d01033751323fb6587a89a00c546b7d90408e20bcb8e08b5ab2b5f2e0"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4711808f39f69b1f45143b73545197813dc6171c7ac5912e28fea7d83806d54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28cb2a184f147ba02e1da3497681b1e40f0a95bfbce159edf9e41316f471a934"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ea0e8557c7c67d6e28f105058bf4c7ac20636d7a48cfcaf869c2322913dc38b"
    sha256 cellar: :any_skip_relocation, ventura:        "2d0d2bf3ad0395e080c97500633ec70a2d42f74604624af749fe2411f5facec7"
    sha256 cellar: :any_skip_relocation, monterey:       "449f5292cb8cb4c629531be95bed883efe4ce8429f00545a93d15f1070563897"
    sha256 cellar: :any_skip_relocation, big_sur:        "e529981c1049cc5e31a7668e87c217b983e334742f01c30b93b512ee1bff1cbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3cff50f3d609ca9f2c210f3451dccd24e30b7e29171f46e3fe2f85a5fc3eb22"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_predicate testpath/"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
