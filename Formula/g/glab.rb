class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.105.0",
    revision: "45c9976d3d33deb99f33410f8c4c919971b4c9cf"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4539fb8d9ff4a5720ce6a5f32efb260f78890c8ffa9314e681eef49c921d3fe8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4539fb8d9ff4a5720ce6a5f32efb260f78890c8ffa9314e681eef49c921d3fe8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4539fb8d9ff4a5720ce6a5f32efb260f78890c8ffa9314e681eef49c921d3fe8"
    sha256 cellar: :any_skip_relocation, sonoma:        "e218d52e5ee8c32825d1d67a7baa0e76955b8f45ca9692a523b9204eb793890c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1da6fa9243e754b5bae3464409de0d1b7b795ae9a708ffa576db0ce3345b9e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "593c198f7e68b44efc2ef066a34ea29fce596e8c92a7af716e1cab864e49125c"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?
    system "make"
    bin.install "bin/glab"
    generate_completions_from_executable(bin/"glab", "completion", "--shell")
  end

  test do
    system "git", "clone", "https://gitlab.com/cli-automated-testing/homebrew-testing.git"
    cd "homebrew-testing" do
      assert_match "Matt Nohr", shell_output("#{bin}/glab repo contributors")
      assert_match "This is a test issue", shell_output("#{bin}/glab issue list --all")
    end
  end
end
