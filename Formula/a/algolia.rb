class Algolia < Formula
  desc "CLI for Algolia"
  homepage "https://www.algolia.com/doc/tools/cli"
  url "https://github.com/algolia/cli/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "34083ff0480baef9cc4fe3339fa605cec9b66f7da89aecadca1256477799f396"
  license "MIT"
  head "https://github.com/algolia/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21e39a4812dbb07883c67bbdde1bb29ffcd233b51f8809c013bc85b443575328"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21e39a4812dbb07883c67bbdde1bb29ffcd233b51f8809c013bc85b443575328"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "21e39a4812dbb07883c67bbdde1bb29ffcd233b51f8809c013bc85b443575328"
    sha256 cellar: :any_skip_relocation, sonoma:        "b59008e3bb8bb0b8df47ed41030b0bdb278fb7f1ccb18a71245c768058cf6223"
    sha256 cellar: :any_skip_relocation, ventura:       "b59008e3bb8bb0b8df47ed41030b0bdb278fb7f1ccb18a71245c768058cf6223"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0da67cd02cfdbfdb136d84a00dcce0dcaddfe7d287d255b9c9d3f76846a5bec3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/algolia/cli/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/algolia"

    generate_completions_from_executable(bin/"algolia", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/algolia --version")

    output = shell_output("#{bin}/algolia apikeys list 2>&1", 4)
    assert_match "you have not configured your Application ID yet", output
  end
end
