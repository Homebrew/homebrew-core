class Gitbackup < Formula
  desc "Tool to backup your Bitbucket, GitHub and GitLab repositories"
  homepage "https://github.com/amitsaha/gitbackup"
  url "https://github.com/amitsaha/gitbackup/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "cd3d042e3aafe76bba7e1d47ee7de89b5b9c33132d352100016daedcbb367bce"
  license "MIT"
  head "https://github.com/amitsaha/gitbackup.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "989b3758a2e2f071075f546d6b6181efd46fd0381442df8a49fd93bd0dc36875"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "989b3758a2e2f071075f546d6b6181efd46fd0381442df8a49fd93bd0dc36875"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "989b3758a2e2f071075f546d6b6181efd46fd0381442df8a49fd93bd0dc36875"
    sha256 cellar: :any_skip_relocation, sonoma:        "6507498acad64888299ae56fa740d3e1f6df54591a46cc5461c6e35a93edc8ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6c4303a2036983ad977fbcc6e5d2a130c6b906fd8dcca1b87fe4c11c349cbfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49dbdf8d2a3e7a54afb26999cb9ca118253983a4d864faf6eac6b398722f675f"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args
  end

  test do
    assert_match "please specify the git service type", shell_output("#{bin}/gitbackup 2>&1", 1)
  end
end
