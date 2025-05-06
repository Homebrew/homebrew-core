class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.11.12.tar.gz"
  sha256 "725f048940791dd56acd2c54e2d0896e7cbb65a5b9896a12e797ef52e3cd0fef"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa031368754a5a721b38c306a9f90fc7fde36b3dd8c8b34cecad51b263766195"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa031368754a5a721b38c306a9f90fc7fde36b3dd8c8b34cecad51b263766195"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fa031368754a5a721b38c306a9f90fc7fde36b3dd8c8b34cecad51b263766195"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfaeb2f8868af83402711efc09bd7868a963731b12ffc044108444e8f86a2431"
    sha256 cellar: :any_skip_relocation, ventura:       "cfaeb2f8868af83402711efc09bd7868a963731b12ffc044108444e8f86a2431"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66b684d44aa8c064a47764aec66bc3f7d17507a191d3f61196a4ec1945d1957a"
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
