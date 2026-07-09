class Globstar < Formula
  desc "Static analysis toolkit for writing and running code checkers"
  homepage "https://globstar.dev"
  url "https://github.com/DeepSourceCorp/globstar/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "72e587b847e75fa751510bacfdf25d035ff3d6290878f1b51d26eeafa03d39e9"
  license "MIT"
  head "https://github.com/DeepSourceCorp/globstar.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d98b7e98ef732c439eff65683513fa96817dde23e8deb1ce2b20ea16586b0fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c858f8619c5e029a36027e5f37561c9464e739df67ea4ba51c8caffe9c48199"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33512e90ba171fe0690ef5cc456c9b771d426cffe71916f4dba6e34241561470"
    sha256 cellar: :any_skip_relocation, sonoma:        "75a72b9b44c4772e04656cbc5c77d34d0d867ad12bee5d4cda512086ab104f6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65b7e231ed78eabc24239dda071cf013ddeed3dbf288e42cfed10a7f7b55d343"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f1571205374898353f21209d57e77d3eedfadfab1d689e69c37b5ce491197f3"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "make", "generate-registry"
    system "go", "build", *std_go_args(ldflags: "-s -w -X globstar.dev/pkg/cli.version=#{version}"), "./cmd/globstar"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/globstar --version")

    output = shell_output("#{bin}/globstar check 2>&1")
    assert_match "Checker directory .globstar does not exist", output
  end
end
