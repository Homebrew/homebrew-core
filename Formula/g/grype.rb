class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.87.0.tar.gz"
  sha256 "487ba946a94e9fe19fbb067e2b636ea784d55c2cbc6c3b3bbb9c2db83ad22012"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cec1bcfaf81a3fd5ef0f3d25d1559e25faec1ea022877016c4ec77ae0c4c8d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64cec4b0be9b3d3fe9b50bb1b90143f7b9f72c8776942206df4d051d5a86b421"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1eb834ff4dd7bf0174668f4760c2c3eabc53666ea3dae11b4bb4334d28d75dad"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e36daa61d4ced9d6533dde284a50f98373e7cec437607a6337e04fcf51ba9c5"
    sha256 cellar: :any_skip_relocation, ventura:       "725d59bd42672f55f0d08619eb45df120ebefcf076393592c9b893c3eb1da724"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae757be7728f6ff8cc0df1cbb6013b5aad9e8d111abcb9ee78d66ccd099e84cc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.gitCommit=#{tap.user} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "update to the latest db", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version 2>&1")
  end
end
