class Gopeed < Formula
  desc "Modern download manager that supports all platform"
  homepage "https://gopeed.com"
  url "https://github.com/GopeedLab/gopeed/archive/refs/tags/v1.6.9.tar.gz"
  sha256 "79148db6a4bb4dbc379e0add68407e78fcbaf06ac67f02f6499812ae802ee765"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c2228209031f4e56c3e28f938dad47f1ee2153f68d335eecd1454f4406abcfc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "628f98a819dad4ad02da70d8923c08538d607c9a594fcb2d4a9e23368890a06b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "45260d8fb3a89fd62f234ce7c72ad1b99741b3f38045a2e5d9758df5cee5b232"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d24f3a118f54fed2d7f99118ef49fcb5693a5828f26d32be487e23653e76b83"
    sha256 cellar: :any_skip_relocation, ventura:       "0be1e753ef7ccfc3eadf4eb9473760c26022de4677c0347dd55104bb45783009"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b5feb2818acd6c007c148458f75cea4a7b75aaafe00fc944ec2ddab1ab61939"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gopeed"
  end

  test do
    output = shell_output("#{bin}/gopeed https://example.com/")
    assert_match "saving path: #{testpath}", output
    assert_match "Example Domain", (testpath/"example.com").read
  end
end
