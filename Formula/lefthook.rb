class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "f4247621abd7ee9860d8c18d6357077978f09e439bde9ff16462e3e743a93ee9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2529bc65e3faefc7d68a28eae19e1b8b5e8a57bb181d6c19aa08a832f951b7ee"
    sha256 cellar: :any_skip_relocation, big_sur:       "70b84e2cffc148328a87c184cf34b92d58678c5fde72446547e954168f7ec8e4"
    sha256 cellar: :any_skip_relocation, catalina:      "dd38c363fb3234d7ad7969402f82434734f5d1e120dbbf278ba0a43838a02c75"
    sha256 cellar: :any_skip_relocation, mojave:        "722d3c1795576fa2bd54a216d9dfdedde6425b056243f605cf2674aa6bf92b04"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_predicate testpath/"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
