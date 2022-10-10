class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "fb7bb8c4863192b13e802605b7787cbd1e733b92bacaf5ff34ea5bbca1a56281"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "261e7799eeb76a9e80a03314f16eb661cedb12af56af54f3873e5823df189205"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b11ed78bbb5ab31f75e254eea02cad5ae0a4f9fee92fbdcd3e3bbc92260a0270"
    sha256 cellar: :any_skip_relocation, monterey:       "42676455649b484ee2f176b4f00e0abb4044163be94d1b32128e027abc04ce63"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b61fbc84a524e212126861888c66d3f0ba981461023efe66db7ab20037b7340"
    sha256 cellar: :any_skip_relocation, catalina:       "ee1fda6492212ef9310af91dad17757edf5817db07b69838ee4e126db6b220e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de993e5beffca2b77065e1d3d612656517fe637e9e6a2da68f8ed6c95669b2b2"
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
