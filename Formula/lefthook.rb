class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "9cce9e8855b64d028a7ef02627e0709d2e7fdbd0664fd66f81f66d01171d4fa5"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dece5967844b1df89607144cff651b738efc132618a00cb684fac092cd14e6d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dece5967844b1df89607144cff651b738efc132618a00cb684fac092cd14e6d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dece5967844b1df89607144cff651b738efc132618a00cb684fac092cd14e6d3"
    sha256 cellar: :any_skip_relocation, ventura:        "628ab1d9a0256995668e6607a9e3646d691d652d5403f5c6596d459711ea6916"
    sha256 cellar: :any_skip_relocation, monterey:       "628ab1d9a0256995668e6607a9e3646d691d652d5403f5c6596d459711ea6916"
    sha256 cellar: :any_skip_relocation, big_sur:        "628ab1d9a0256995668e6607a9e3646d691d652d5403f5c6596d459711ea6916"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73602909c5607391409bfbd9df405716f5b2453e48f130b50d9272c9cfe1f93a"
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
