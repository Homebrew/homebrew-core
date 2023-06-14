class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "b02085764aa2668c877cff8844bbf07ca1a9d87dccd76445b000f16b32e792ad"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0aabeb060a25c5f1d2aae2ba5a1ddcc348eb85f22bf175bec279dd969c4d5801"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0aabeb060a25c5f1d2aae2ba5a1ddcc348eb85f22bf175bec279dd969c4d5801"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0aabeb060a25c5f1d2aae2ba5a1ddcc348eb85f22bf175bec279dd969c4d5801"
    sha256 cellar: :any_skip_relocation, ventura:        "11e7c6ab333abd91d81ad78be523d2805d36a8d75d85586c4e80c957922bf6ff"
    sha256 cellar: :any_skip_relocation, monterey:       "11e7c6ab333abd91d81ad78be523d2805d36a8d75d85586c4e80c957922bf6ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "11e7c6ab333abd91d81ad78be523d2805d36a8d75d85586c4e80c957922bf6ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ea492527412f915a456cd7c89460a3d17bc83d0641f3c5414fed8ea6c6862eb"
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
