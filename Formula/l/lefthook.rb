class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.4.10.tar.gz"
  sha256 "c40f43db2f75061505ba4faae58c5da24803dcad33d009f2430d194a11b49b4b"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5f1f6c56d7b9ab8a395dec0a2202f9430f98d722577369906f7ed474dfb46cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "862bb8f69e369b9022b0b82a8260d4c5c6dadf39efff32590578e78fc0bb2ef7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8bf61536b06c3d50531664ff7bbb03e6219970031e88a7a32b8d5dc6d060e515"
    sha256 cellar: :any_skip_relocation, ventura:        "b285ce76f0f1e0bdf53d5e4dfd728ee6663e95f18ca9541de4e7b4112cc34bc0"
    sha256 cellar: :any_skip_relocation, monterey:       "7551b0bbfda030820704acd30b5741b2ebbed1be69f6bb705ef00d166a78a0ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf91c38b1691392e2d3b32a909e40952fd8cce663780da7bb253bc2a04f86866"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39580cc3f0f1d1e3f0d40588f52d5d7449581deec1861434a1bd1d21bf99ca7f"
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
