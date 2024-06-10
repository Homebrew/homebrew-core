class Flowpipe < Formula
  desc "Cloud scripting engine"
  homepage "https://flowpipe.io"
  url "https://github.com/turbot/flowpipe/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "9e11f3d5d3ba91e5d9bd4fb7b0f25920700f6770949b513537297707c4cb7571"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e5142b753ec7d6abecd4c102601537972013c92222a2da4ecc5103b43d19b5c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b1d1022facf0a8f9b4bbdd6b876e5cbb8c7df7981aa169b0485a6f086f4ee10"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8cd933d9ebea8078810d3449ebf071aa0273802acb8904ae3c47a188aa2f7742"
    sha256 cellar: :any_skip_relocation, sonoma:         "9e7127b81c615ebc60869d4d6f909667002c3d885efe86c60986a5c0629c6187"
    sha256 cellar: :any_skip_relocation, ventura:        "20da1424d3ee7f5e66b4d6f8d147ff25c759d44f7409a5df294c35a6228c1045"
    sha256 cellar: :any_skip_relocation, monterey:       "c1d9905a955d7aed22f0d6862e3ba8aaa70d066cb91d4fa878341d80c82a1777"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81acb96880888565bda2145cd0e9c44d8b49a876ff69fe76886646dcff1e826a"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    cd "ui/form" do
      system "yarn", "install"
      system "yarn", "build"
    end

    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X version.buildTime=#{time.iso8601}
      -X version.commit=#{tap.user}
      -X version.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flowpipe -v")

    output = shell_output(bin/"flowpipe mod list 2>&1")
    if OS.mac?
      assert_match "Error: could not create sample workspace", output
    else
      assert_match "No mods installed.", output
    end
  end
end
