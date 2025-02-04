# typed: strict
# frozen_string_literal: true

# Formula for llmdog, a tool to prepare files for LLM consumption.
class Llmdog < Formula
  desc "Prepare files for LLM consumption"
  homepage "https://github.com/doganarif/llmdog"
  license "MIT"

  if Hardware::CPU.arm?
    url "https://github.com/doganarif/llmdog/releases/download/v1.0.0/llmdog_v1.0.0_darwin_arm64.tar.gz"
    sha256 "e49a0895db86f26afbf58fbbda36235969567e8813f652b8623e1432237f3a01"
  else
    url "https://github.com/doganarif/llmdog/releases/download/v1.0.0/llmdog_v1.0.0_darwin_amd64.tar.gz"
    sha256 "a9ae51041ca15bc8c8e9060eb8181e23b175ec67dfdc179796453b263d3dc39b"
  end

  depends_on "go" => :build

  def install
    # Assumes the tarball contains a prebuilt binary named "llmdog"
    bin.install "llmdog"
  end

  test do
    assert_match "llmdog version", shell_output("#{bin}/llmdog --version")
  end
end
