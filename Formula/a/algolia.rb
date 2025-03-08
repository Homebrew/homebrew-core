class Algolia < Formula
  desc "CLI for Algolia"
  homepage "https://www.algolia.com/doc/tools/cli"
  url "https://github.com/algolia/cli/archive/refs/tags/v1.6.11.tar.gz"
  sha256 "0965dadab1519128130532141701efbf56310f7cb9735c1da596cf6f2aad4657"
  license "MIT"
  head "https://github.com/algolia/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3838d70240aaee37f970111e75b7bcaf0f6f072dd7f6c38b74d802abf192c76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3838d70240aaee37f970111e75b7bcaf0f6f072dd7f6c38b74d802abf192c76"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e3838d70240aaee37f970111e75b7bcaf0f6f072dd7f6c38b74d802abf192c76"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f9f58f1756da53c7323aeafc4e571ab02f581233f2de04de9f06239b77e6e50"
    sha256 cellar: :any_skip_relocation, ventura:       "7f9f58f1756da53c7323aeafc4e571ab02f581233f2de04de9f06239b77e6e50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d96519f4745556eb24812382b9ca4682bd8196af3f648a2895240b13937ae61d"
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
