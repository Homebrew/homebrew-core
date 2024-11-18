class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.8.4.tar.gz"
  sha256 "e8e49bc5796f7cd035379cdb7df6afd335ee5687e6a6d4377a793e4fdc1cf467"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25ab4ab7645afe5030664c163ed92d0b09f1a4ab5cc058d4234d830659f00fd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25ab4ab7645afe5030664c163ed92d0b09f1a4ab5cc058d4234d830659f00fd5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "25ab4ab7645afe5030664c163ed92d0b09f1a4ab5cc058d4234d830659f00fd5"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1d33e2a26facab8b7a6f9b295b1dd5834e5e1eb94353d3b5b0a2c84cf389b29"
    sha256 cellar: :any_skip_relocation, ventura:       "a1d33e2a26facab8b7a6f9b295b1dd5834e5e1eb94353d3b5b0a2c84cf389b29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d6e7681d7cff90e681d4d5d5ea07b8b945635b391c16ed48da39c863b7eb8c3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-tags", "no_self_update", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_predicate testpath/"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
