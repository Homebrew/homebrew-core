class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.app/"
  url "https://github.com/danvergara/dblab/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "41fd691aca6f433f8795ca88a0fdfc5e68d662a00b2e4d6d4ec80537bc71a744"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cef4035aad5f28aa94f7d9e24b6939abd5e1b76922ff848284482711bb576a54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "238e80f6a5b32ddd46182da8885e75acd84f7e9b04ab9c5f1c3f6a880598e99e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc2cbe404fd4ead037a29bd1e5cced2ec4d717176e636b093e59ab5a35dc6388"
    sha256 cellar: :any_skip_relocation, sonoma:        "66a68c114319b3a998d4c04eb1e681eee47a73b8d798e8e4cab4ae7331ace7a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b85b794c068cfdd94b49c40f8dee1a068872ecb105413e70ac127aecb348b932"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82a7ac29c265eaf5bbde35bb5c08d4d7589ea9b1ab06647cccff87e410bd97c0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"dblab", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dblab --version")

    output = shell_output("#{bin}/dblab --url mysql://user:password@tcp\\(localhost:3306\\)/db 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end
