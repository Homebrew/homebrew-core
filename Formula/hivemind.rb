class Hivemind < Formula
  desc "Process manager for Procfile-based applications"
  homepage "https://github.com/DarthSim/hivemind"
  url "https://github.com/DarthSim/hivemind/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "b4f7259663ef5b99906af0d98fe4b964d8f9a4d86a8f5aff30ab8df305d3a996"
  license "MIT"
  head "https://github.com/DarthSim/hivemind.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8ca06b6d2dde91c66cd6af2396a58b40e6be52e51fa738f24ff2e23376dc60a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8ca06b6d2dde91c66cd6af2396a58b40e6be52e51fa738f24ff2e23376dc60a"
    sha256 cellar: :any_skip_relocation, monterey:       "eaedb2b4739dc4e668ae9bf563750e1bb54fea1f16e800f6bf496226dc1daff0"
    sha256 cellar: :any_skip_relocation, big_sur:        "eaedb2b4739dc4e668ae9bf563750e1bb54fea1f16e800f6bf496226dc1daff0"
    sha256 cellar: :any_skip_relocation, catalina:       "eaedb2b4739dc4e668ae9bf563750e1bb54fea1f16e800f6bf496226dc1daff0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c702f980c6b3a024c20bd50af65de981ab55b360e10013b22aa6797d834f7c85"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"Procfile").write("test: echo 'test message'")
    assert_match "test message", shell_output("#{bin}/hivemind")
  end
end
