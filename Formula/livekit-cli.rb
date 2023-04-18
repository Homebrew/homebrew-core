class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v1.2.4.tar.gz"
  sha256 "c20b21de66861edf6250faa939757aae2e657529f5d9db6f97ca1d8366e6afe3"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d08692e5dea1d80df9b5e59c3156f1bae0bc84d2bd2df751b16f130b75bd92c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7a6dfa3dbc91cbf1c535e278346b1bd1d2410920b8a085cb73c600b50eee58f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a29d106daa1960afef9c578a55b7f729f25212264fc5c8f692bf32989c7c80a8"
    sha256 cellar: :any_skip_relocation, ventura:        "49ef344206e0da7def00cee239b3e7d36a809c4cd235b7a14ea24588d0cb31b1"
    sha256 cellar: :any_skip_relocation, monterey:       "be8f75691f2b9f433b11731f3956b9c6d3b472f198d476d1336c23771379c8b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "b664804cc9e900fd862752687926429dec1f2f93b4d8220d428017db656ae563"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7b1331ec5b761793999fb1fde9cefe4d017729438d46a156f0d4f3c1f14dc98"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/livekit-cli"
  end

  test do
    output = shell_output("#{bin}/livekit-cli create-token --list --api-key key --api-secret secret")
    assert output.start_with?("valid for (mins):  5")
    assert_match "livekit-cli version #{version}", shell_output("#{bin}/livekit-cli --version")
  end
end
