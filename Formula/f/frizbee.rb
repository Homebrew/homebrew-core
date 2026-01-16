class Frizbee < Formula
  desc "Throw a tag at and it comes back with a checksum"
  homepage "https://github.com/stacklok/frizbee"
  url "https://github.com/stacklok/frizbee/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "71ad0532b478c942b74c53e5ddec45df4b737d4db05192bc899d2ba7ff0a2196"
  license "Apache-2.0"
  head "https://github.com/stacklok/frizbee.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e7dccf5ade7ee183fb6e8672e0bcc0aa18e8667c25e31ca2da54818e5cba372"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e7dccf5ade7ee183fb6e8672e0bcc0aa18e8667c25e31ca2da54818e5cba372"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e7dccf5ade7ee183fb6e8672e0bcc0aa18e8667c25e31ca2da54818e5cba372"
    sha256 cellar: :any_skip_relocation, sonoma:        "57d0f4e933b040caaaf10263f457f0112ea4f77b59a848edebcf117841deede1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed5ad38b59e10f8ee3853f6c542dd272185b638be61c3abba1408372b76735cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58a62928bbff93823a2fadaef5c7d6f4ec145decbd199d4bd7e0c3966b1479b4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/stacklok/frizbee/internal/cli.CLIVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"frizbee", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/frizbee version 2>&1")

    output = shell_output("#{bin}/frizbee actions $(brew --repository)/.github/workflows/tests.yml 2>&1")
    assert_match "Processed: tests.yml", output
  end
end
