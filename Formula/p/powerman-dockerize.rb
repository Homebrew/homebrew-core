class PowermanDockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/powerman/dockerize"
  url "https://github.com/powerman/dockerize.git",
      tag:      "v0.24.0",
      revision: "98df0a9e614d389b06622bb66b44481011fc16c5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa4531120658b5d83e82f63c80be0e774e8057f8c984369625e536ae2f582b42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4f03c8b8543e474af29da228cea9608fc3e0126ef4ecf14042f423be17c73be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4f03c8b8543e474af29da228cea9608fc3e0126ef4ecf14042f423be17c73be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f4f03c8b8543e474af29da228cea9608fc3e0126ef4ecf14042f423be17c73be"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a8423454af9a78459fc06ec92374092403780afa12d59ac277551c8038cd140"
    sha256 cellar: :any_skip_relocation, ventura:       "7a8423454af9a78459fc06ec92374092403780afa12d59ac277551c8038cd140"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "021e00cfb5fb36a6b7a81850abd8cc9fbb9276f16238f5b5f3b6531db5d2b872"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34b68e1e44ae7024f51d75786c99ff2822c73cf59cc54f285bb8e151b3b7451f"
  end

  depends_on "go" => :build
  conflicts_with "dockerize", because: "powerman-dockerize and dockerize install conflicting executables"

  def install
    system "go", "build", *std_go_args(output: bin/"dockerize", ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerize --version")
    system bin/"dockerize", "-wait", "https://www.google.com/", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end
