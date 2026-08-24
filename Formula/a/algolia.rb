class Algolia < Formula
  desc "Command-line tool to manage Algolia applications, accounts, and search resources"
  homepage "https://www.algolia.com/doc/tools/cli/get-started"
  url "https://github.com/algolia/cli/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "eac19d1691e42b912c8bd7e148eba6305b7f7c6e61e6a03f398644552143bdd7"
  license "MIT"
  head "https://github.com/algolia/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be39cb31e298f6d6da8d84640a336b97658147ba38a20fa8f767edf41b2cc0fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be39cb31e298f6d6da8d84640a336b97658147ba38a20fa8f767edf41b2cc0fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be39cb31e298f6d6da8d84640a336b97658147ba38a20fa8f767edf41b2cc0fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fb24099b8c1bb363b37b222908f73fd9a61be6181b6f88caf620bec7fa54362"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8b64c026a0d16bf8fd6eccf987fb56eb88d00edd3b09ac4cb27ca6ac1a05b8b"
    sha256 cellar: :any,                 x86_64_linux:  "06e7604df41ac8bcaa323c3d267d4c789d4ebebf7ad6702439cb4a033a84cef3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/algolia/cli/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/algolia"

    generate_completions_from_executable(bin/"algolia", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/algolia --version")

    output = shell_output("#{bin}/algolia apikeys list 2>&1", 4)
    assert_match "you have not configured your Application ID yet", output
  end
end
