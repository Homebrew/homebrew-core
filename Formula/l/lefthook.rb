class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "288d80db62c6bd90111850a546ca061ac7268c2fb3a4f6cf606a3cb1f9434c23"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e19b79290e2779e6dc5141c3ecbd825581f1a66b4342d147c4b7bd1c015d5ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e19b79290e2779e6dc5141c3ecbd825581f1a66b4342d147c4b7bd1c015d5ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e19b79290e2779e6dc5141c3ecbd825581f1a66b4342d147c4b7bd1c015d5ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "f07eb3df2b1be4d2208791e40eeccf0fc0cae366c7322252fc9b9d7fef7ba034"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c58e8ba4d82b303c713f8d6a22efe5ac4284d26384cb1620be604f28b00e61b2"
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
