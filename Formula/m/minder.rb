class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https://mindersec.github.io/"
  url "https://github.com/mindersec/minder/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "9046597b7682e972dbf9fc3b9a363663d46e3126da005c067c899bc9767b248c"
  license "Apache-2.0"
  head "https://github.com/mindersec/minder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aeed25ec1f7c8fe7a9f69f17e94245d223be8678c6bff126b69e6bc8e3fc6632"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aeed25ec1f7c8fe7a9f69f17e94245d223be8678c6bff126b69e6bc8e3fc6632"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aeed25ec1f7c8fe7a9f69f17e94245d223be8678c6bff126b69e6bc8e3fc6632"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9a83f01b9872bb3497781429d979bfad4771a1ce35166be15d932ad411681af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3361fab41ae2a457a6b3e451ea3a37fdbc76441ad8a26f52d9bbfd3d61329692"
    sha256 cellar: :any,                 x86_64_linux:  "92b24cb7be24dcceb1e8ed51d6bcbd7d95eb5fad7284baf9e8572f130927e4d4"
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
