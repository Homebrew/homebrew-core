class Gtree < Formula
  desc "Generate directory trees and directories using Markdown or programmatically"
  homepage "https://ddddddo.github.io/gtree/"
  url "https://github.com/ddddddO/gtree/archive/refs/tags/v1.11.4.tar.gz"
  sha256 "a1c82e8abedee86d022c9c1cc65d69485c4b25fbb38c46d78714ad067c1e010b"
  license "BSD-2-Clause"
  head "https://github.com/ddddddO/gtree.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f1a16fe88082f38a4554177b05d52e24d713c9cbeebb71bbbdd84daa91b68cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f1a16fe88082f38a4554177b05d52e24d713c9cbeebb71bbbdd84daa91b68cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f1a16fe88082f38a4554177b05d52e24d713c9cbeebb71bbbdd84daa91b68cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "aadb9b968b9139a14931a78231c9d4b0345663d3f292a1b5e4be6f1df5b2959b"
    sha256 cellar: :any_skip_relocation, ventura:       "aadb9b968b9139a14931a78231c9d4b0345663d3f292a1b5e4be6f1df5b2959b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c57024bd481544394d806052d1ac76db91d03e780ed238e5c9a48aaa109aeb66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b816029df2cde17c3ddb1be71f0d9fcbfe12c9b13865babf4805124d68a36a09"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Revision=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gtree"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gtree version")

    assert_match "testdata", shell_output("#{bin}/gtree template")
  end
end
