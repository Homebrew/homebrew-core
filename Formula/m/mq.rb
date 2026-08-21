class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://github.com/harehare/mq/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "c47874259da3fb1121887e05995ce5992e126d16aad1374f2128adb36b19198d"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6604239016daa434aae5c111c12da2d3091234b4ae7f8ec95c1499ac6a16c80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e528d33cc81181fb66fdd737af681bb569f5275dcbec9fe8746ed4bce7b2eb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ef4f08cda60c9c599ed59cf0b06ef618f4c9765577477f93235f404a766e8dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "7680eae66d8a47bc61826a01ad0bbd526a1d749b886fc2336f84707bde31e762"
    sha256 cellar: :any,                 arm64_linux:   "b0a7e9a8f1111b27380f7582296342c284adeed51241d55fc34943b60b18c0d8"
    sha256 cellar: :any,                 x86_64_linux:  "9fdd89c9fb5d7e5eab830b89a76bc086695a0ae33b75b7360fe126ff8ee849d5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/mq-run")
    system "cargo", "install", *std_cargo_args(path: "crates/mq-lsp")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mq --version")

    (testpath/"test.md").write("# Hello World\n\nThis is a test.")
    output = shell_output("#{bin}/mq '.h' #{testpath}/test.md")
    assert_equal "# Hello World\n", output
  end
end
