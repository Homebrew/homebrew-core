class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "d011335abc339361424c5298f01cdb341f2c5ede6e4eddd9ca24bc155e5d3087"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dbf2b3e772317410b25089f26b920270018e8577c7e67cab059dee9e706d669f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbf2b3e772317410b25089f26b920270018e8577c7e67cab059dee9e706d669f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dbf2b3e772317410b25089f26b920270018e8577c7e67cab059dee9e706d669f"
    sha256 cellar: :any_skip_relocation, ventura:        "91a6bfc69e873d6073b7fc8a711ae7b70a2b634cae74e3af7fdac6901f85be6a"
    sha256 cellar: :any_skip_relocation, monterey:       "91a6bfc69e873d6073b7fc8a711ae7b70a2b634cae74e3af7fdac6901f85be6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "91a6bfc69e873d6073b7fc8a711ae7b70a2b634cae74e3af7fdac6901f85be6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46649471b61da368971a7d4be501904f989f6d9eedb447e3e916b4c8c3e26aad"
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
