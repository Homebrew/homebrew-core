class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.13.0",
      revision: "d267284e9914d92a7fd20d9151412c6b11f5f59e"
  license "Apache-2.0"
  head "https://github.com/lacework/go-sdk.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b36a493cdeab10fd0666a6131b8c0815ddf87d4f835ef7a675e2dbca26e5bc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b36a493cdeab10fd0666a6131b8c0815ddf87d4f835ef7a675e2dbca26e5bc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b36a493cdeab10fd0666a6131b8c0815ddf87d4f835ef7a675e2dbca26e5bc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "b19f7a4c7c61530079ee32e6d7b4da383ee58350d656a834377f49b017073e6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7e3701019c3f753895d0f09c6d80895da58cb9e163ab657d821f8de9f858184"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5d8ae313acee94ed9da023e14464420363619c201d959cdd873f65c96fa4464"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/lacework/go-sdk/v2/cli/cmd.Version=#{version}
      -X github.com/lacework/go-sdk/v2/cli/cmd.GitSHA=#{Utils.git_head}
      -X github.com/lacework/go-sdk/v2/cli/cmd.HoneyDataset=lacework-cli-prod
      -X github.com/lacework/go-sdk/v2/cli/cmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(output: bin/"lacework", ldflags:), "./cli"

    generate_completions_from_executable(bin/"lacework", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lacework version")

    output = shell_output("#{bin}/lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end
