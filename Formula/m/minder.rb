class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https://mindersec.github.io/"
  url "https://github.com/mindersec/minder/archive/refs/tags/v0.0.88.tar.gz"
  sha256 "752125949347cf697aade1a23369c3b7b86dd9011b3be1459c4843c2025ea0a6"
  license "Apache-2.0"
  head "https://github.com/mindersec/minder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12e7bca3e23d532e50302b68e40a805ade409431bc42e62d8580882af2a30579"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12e7bca3e23d532e50302b68e40a805ade409431bc42e62d8580882af2a30579"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "12e7bca3e23d532e50302b68e40a805ade409431bc42e62d8580882af2a30579"
    sha256 cellar: :any_skip_relocation, sonoma:        "95a24ac545e68d55f7b664916a85b3e040dccee7b214bd43207f002868129bcc"
    sha256 cellar: :any_skip_relocation, ventura:       "c4d7cf1e1aef98f015ba729c0090c67ef3432db85aaff82f8d541237cc1d3a8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80bed709b6d1a773c272070d89710b8b01e63e62ec0f40b74e01540dcbe1f4a1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/mindersec/minder/internal/constants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minder version")

    output = shell_output("#{bin}/minder artifact list -p github 2>&1", 16)
    assert_match "No config file present, using default values", output
  end
end
