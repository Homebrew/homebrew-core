class Frizbee < Formula
  desc "Throw a tag at and it comes back with a checksum"
  homepage "https://github.com/stacklok/frizbee"
  url "https://github.com/stacklok/frizbee/archive/refs/tags/v0.1.11.tar.gz"
  sha256 "e340a92a712b5214e7e6cbf5c7b29c334012cb41d2607c9545106fc73c543546"
  license "Apache-2.0"
  head "https://github.com/stacklok/frizbee.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe319cd42db4d53c25d774f399fd6ef42fbe367dffff73e4e2f32a7e4a09002a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe319cd42db4d53c25d774f399fd6ef42fbe367dffff73e4e2f32a7e4a09002a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe319cd42db4d53c25d774f399fd6ef42fbe367dffff73e4e2f32a7e4a09002a"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd1f4b851bfb272311ec20fd5d701674adc080dc2e3807651075b7e9b371a83a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "825d40ddf19f5fce0a95d2ee8a267e9f9a993153d7576f96cfa88b3e0cffa433"
    sha256 cellar: :any,                 x86_64_linux:  "c7fe6b480b477f96fad69320c94a6a6eccec9a835504b3f1613f1ff9b19d6d53"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/stacklok/frizbee/internal/cli.CLIVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"frizbee", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/frizbee version 2>&1")

    output = shell_output("#{bin}/frizbee actions $(brew --repository)/.github/workflows/tests.yml 2>&1")
    assert_match "Processed: tests.yml", output
  end
end
