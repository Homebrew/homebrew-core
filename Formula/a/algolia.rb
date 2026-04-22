class Algolia < Formula
  desc "CLI for Algolia"
  homepage "https://www.algolia.com/doc/tools/cli/get-started"
  url "https://github.com/algolia/cli/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "f9c2ef7e61206481487d3b2762e81ddcdd77280cd371b17b5eacc6240813ab60"
  license "MIT"
  head "https://github.com/algolia/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aaba30a3098f59a267f81e5aaa5ad4968ee8cb728dd0ab4f454bba4aee433293"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aaba30a3098f59a267f81e5aaa5ad4968ee8cb728dd0ab4f454bba4aee433293"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aaba30a3098f59a267f81e5aaa5ad4968ee8cb728dd0ab4f454bba4aee433293"
    sha256 cellar: :any_skip_relocation, sonoma:        "36d636373e422836119046851b658718435e66a7742227fab7d8c2ed9fb0b9dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "354c761cfcad40bc39d82e075a161c02d24695f086bedf3d2cc628ceb8d045b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0ee48c7d47c573ce1c78c3eccb1cdc70c6b8f5b677882be089a69cf1f811ca4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/algolia/cli/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/algolia"

    generate_completions_from_executable(bin/"algolia", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/algolia --version")

    output = shell_output("#{bin}/algolia apikeys list 2>&1", 4)
    assert_match "you have not configured your Application ID yet", output
  end
end
