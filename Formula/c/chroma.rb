class Chroma < Formula
  desc "General purpose syntax highlighter in pure Go"
  homepage "https://github.com/alecthomas/chroma"
  url "https://github.com/alecthomas/chroma/archive/refs/tags/v2.18.0.tar.gz"
  sha256 "d3ff19a0007222f1674f3d751f8702073fc95b7c293c595a3c36b57275c1bde5"
  license "MIT"
  head "https://github.com/alecthomas/chroma.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e44eea80b9052a9b2b1b2a92ecf438d3c931535b78c946a667e2e1d6916fa3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e44eea80b9052a9b2b1b2a92ecf438d3c931535b78c946a667e2e1d6916fa3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9e44eea80b9052a9b2b1b2a92ecf438d3c931535b78c946a667e2e1d6916fa3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a339f6ed5e866b77c20ed4d97bad1020beaf64776ba81d720e6f7f1cde52c8c2"
    sha256 cellar: :any_skip_relocation, ventura:       "a339f6ed5e866b77c20ed4d97bad1020beaf64776ba81d720e6f7f1cde52c8c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ae6483a4b7e13434144ae969bb1c71f0cf9829b3f328c891cf634a3b68f1d39"
  end

  depends_on "go" => :build

  def install
    cd "cmd/chroma" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    json_output = JSON.parse(shell_output("#{bin}/chroma --json #{test_fixtures("test.diff")}"))
    assert_equal "GenericHeading", json_output[0]["type"]
  end
end
