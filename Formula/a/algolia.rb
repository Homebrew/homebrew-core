class Algolia < Formula
  desc "Command-line tool to manage Algolia applications, accounts, and search resources"
  homepage "https://www.algolia.com/doc/tools/cli/get-started"
  url "https://github.com/algolia/cli/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "be682931be671f209297c5ee9bcdeb90fb9dd16a051fb90d79d8c4ebe877ac08"
  license "MIT"
  head "https://github.com/algolia/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "054ffd14690abb97ca044103d218d6a00c1b1d6aa933b16cf0b74ea6b6d725aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "054ffd14690abb97ca044103d218d6a00c1b1d6aa933b16cf0b74ea6b6d725aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "054ffd14690abb97ca044103d218d6a00c1b1d6aa933b16cf0b74ea6b6d725aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ba859c26cdb1cdd7057edf23d69b0c7f181fdefbe64e0d614f1fb768e1a43fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b7d06b33220a0271515f98e983595aaa298752ce725ca5a18f9ff6442c2dcb0"
    sha256 cellar: :any,                 x86_64_linux:  "95540d906bc870c66a788c6024303027a4aa95eb2c2297005cd88438bc47b55c"
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
