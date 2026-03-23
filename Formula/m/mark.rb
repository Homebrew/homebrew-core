class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://github.com/kovetskiy/mark"
  url "https://github.com/kovetskiy/mark/archive/refs/tags/v16.0.0.tar.gz"
  sha256 "9d4d81a0d8acf9c09ae46b4bdb4732d091abd14912574d56bf7f443a591fed52"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5a85a71085c14b7d8488e8f7aa838a02a2757f95f3962a95e09daee6c24079d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5a85a71085c14b7d8488e8f7aa838a02a2757f95f3962a95e09daee6c24079d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5a85a71085c14b7d8488e8f7aa838a02a2757f95f3962a95e09daee6c24079d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b693fb86b48f20c3ccf5eb7d553e27dd0c32282d64535604719cf0710bca61b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e530db05417bd94ac93942d2d5156672845daf64671f500e88d0df52b758178"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e129c9f55ece94fe6e53b219ac3c2b27d8a9c8430d6e9694f0d2e3adad9d046"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/mark"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mark --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello Homebrew
    MARKDOWN

    output = shell_output("#{bin}/mark --config nonexistent.yaml sync 2>&1", 1)
    assert_match "FATAL confluence password should be specified", output
  end
end
