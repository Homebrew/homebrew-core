class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  url "https://github.com/Azure/azqr.git",
      tag:      "v.2.2.0",
      revision: "0dab1442ebb47dd3f8e2ab82beeb328d4f287fcf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07077125faa4d4e10e820ef58cede8462f8f70d80dfd45f8645cbe4b69ce7281"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07077125faa4d4e10e820ef58cede8462f8f70d80dfd45f8645cbe4b69ce7281"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "07077125faa4d4e10e820ef58cede8462f8f70d80dfd45f8645cbe4b69ce7281"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8840d088702c9b71802b1bef8222e74ec8a13602ef1ce91e1e00c73d0c1f07a"
    sha256 cellar: :any_skip_relocation, ventura:       "c8840d088702c9b71802b1bef8222e74ec8a13602ef1ce91e1e00c73d0c1f07a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54bded151339de4030b2dd768291cdcce889f2f20bc06ad376341319756a0134"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/Azure/azqr/cmd/azqr.version=#{version}"), "./cmd"

    generate_completions_from_executable(bin/"azqr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azqr -v")
    output = shell_output("#{bin}/azqr scan --filters notexists.yaml 2>&1", 1)
    assert_includes output, "failed reading data from file"
    output = shell_output("#{bin}/azqr scan 2>&1", 1)
    assert_includes output, "Failed to list subscriptions"
  end
end
