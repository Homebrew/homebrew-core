class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https://mindersec.github.io/"
  url "https://github.com/mindersec/minder/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "10119636e4ad41cbbe1b3627511a23d14834b68fdb503b23edb07b3a450fe5ed"
  license "Apache-2.0"
  head "https://github.com/mindersec/minder.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f738bb44dccf7827a70b8671b5f96dae7e992dea9cf5bec5a6fc944771094a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f738bb44dccf7827a70b8671b5f96dae7e992dea9cf5bec5a6fc944771094a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f738bb44dccf7827a70b8671b5f96dae7e992dea9cf5bec5a6fc944771094a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c2f6a4cbde2279dfd58dbe45a55f7e1bdaede9a2ae36b8526b6ee47f25d0fe8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25e714b094bd5ec8adce20fd12354d0fb77335c87bc8cb4a53bdaf151c4ee0d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f44a33ac221f3db00805728a799ef75aee18199e2e6c7f79fe5343ea61a977e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/mindersec/minder/internal/constants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"minder", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minder version 2>&1")

    # All the cli action trigger to open github authorization page,
    # so we cannot test them directly.
  end
end
