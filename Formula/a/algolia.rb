class Algolia < Formula
  desc "CLI for Algolia"
  homepage "https://www.algolia.com/doc/tools/cli/get-started"
  url "https://github.com/algolia/cli/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "3757d76ed2a9c341fb5f1a4cb8e2e7465ac17753eb489bb5fae2f4df10c6302b"
  license "MIT"
  head "https://github.com/algolia/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed3fe3b5b7f0a90081443986fbe756dfd14fc828fa3b50944dd6a2d3e64139ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed3fe3b5b7f0a90081443986fbe756dfd14fc828fa3b50944dd6a2d3e64139ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed3fe3b5b7f0a90081443986fbe756dfd14fc828fa3b50944dd6a2d3e64139ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed3fe3b5b7f0a90081443986fbe756dfd14fc828fa3b50944dd6a2d3e64139ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "b67032c92b32eeb4bd79836b6d2c09d6a8e0cc05ff0fa02bbf7cb1b6889d7501"
    sha256 cellar: :any_skip_relocation, ventura:       "b67032c92b32eeb4bd79836b6d2c09d6a8e0cc05ff0fa02bbf7cb1b6889d7501"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "048383a03e88f4a83dbf333ad4daf895100cfabcf35adf6f5a9fea9dd452c738"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a448e8b052d4ed8cb044cfcb74bb3b33be7e7a9c92853babff6b476224a81355"
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
