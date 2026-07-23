class Goresym < Formula
  desc "Go symbol recovery tool"
  homepage "https://github.com/mandiant/GoReSym"
  url "https://github.com/mandiant/GoReSym/archive/refs/tags/v3.4.tar.gz"
  sha256 "1c6b703ca1e5db08b93a6d602c826ea6dc7eee8502a0b2f4ad358113d8f513fc"
  license "MIT"
  head "https://github.com/mandiant/GoReSym.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0c3dd1beaa650082bf2464e79304ac8024741122d364d8dd3e7bb58b72b526b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0c3dd1beaa650082bf2464e79304ac8024741122d364d8dd3e7bb58b72b526b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0c3dd1beaa650082bf2464e79304ac8024741122d364d8dd3e7bb58b72b526b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9404f725543a4c25b8e1940ffeb3b58d77a7be05551420ba51ce2dc2e6833d06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b146d6338145c53d8bf12592f588fc6a644daf7f26bfd8c4cc73e6aa06d7e28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63de26c635c15de736ecfba0ea0e97befe73c3ae06c3fee3323772fafa9fa015"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = JSON.parse(shell_output("#{bin}/goresym '#{bin}/goresym'"))
    assert_equal output["BuildInfo"]["Main"]["Path"], "github.com/mandiant/GoReSym"
  end
end
