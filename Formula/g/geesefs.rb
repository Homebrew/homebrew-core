class Geesefs < Formula
  desc "FUSE FS implementation over S3"
  homepage "https://github.com/yandex-cloud/geesefs"
  url "https://github.com/yandex-cloud/geesefs/archive/refs/tags/v0.43.5.tar.gz"
  sha256 "37fb37fc4f15dc553693a268ef9bf3ca27d8f5f5ebb580a4fc4e869f235d528d"
  license "Apache-2.0"
  head "https://github.com/yandex-cloud/geesefs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e31f7849b96b9ba604d69570a31d6e4f71defa4834611701a6d222a916e3f91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1115e48c3c493faa3bf75fb7ab34095c0282870a510ad7a9f1b1ca262a57c07f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8da705c6595b27b9aed6d28d7f70523cadbbd2d39c43798ddd9f496b952840e"
    sha256 cellar: :any_skip_relocation, sonoma:        "62f92419fa6f16eb22765bf270ccb1eb40abea1a161ea775d9aba0388c121f73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7be4f2794c34e2c0236b0f06e280d956181c863fa0bcfcd3b66cc244fabeb7b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3681fb383753925bdad905b8bc65c942441d1fbb56ee6f6882a2e7b9ef39baf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "geesefs version #{version}", shell_output("#{bin}/geesefs --version 2>&1")
    output = shell_output("#{bin}/geesefs test test 2>&1", 1)
    assert_match "FATAL Mounting file system: Unable to access 'test'", output
  end
end
