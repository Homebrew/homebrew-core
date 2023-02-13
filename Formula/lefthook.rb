class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.2.9.tar.gz"
  sha256 "77b396c516366db5ef2d0f4d49b5bdb543c340b60e1e63b777a781b99634d750"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "425db631fec219ebfc345263c34810ea838d8d30afc61c1cad0aa3fc8c79143a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d61bc601b86de7510175fd8daa7ab18df6d42156dd824a248629167ee691c86c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "acd59ef2c02a66adb51b5fe7330d81d898b3cb65ca403515ef5f145d70a87c7e"
    sha256 cellar: :any_skip_relocation, ventura:        "23761e53ab3099c3ea07d186b83c16057bd41bc712a95cc089af81348e4d5255"
    sha256 cellar: :any_skip_relocation, monterey:       "b9089a6e125a43224e812118d3d30b92c5c862aea657e9d87c10a036c2a73372"
    sha256 cellar: :any_skip_relocation, big_sur:        "242c28796481feb7d54431030f399dbcb56770a38825f71178199b0cc9e6c3bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1dcd25b1e92e0f6d387fff20ab80caa1192da261e81d510e3abe26806cbea12d"
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
