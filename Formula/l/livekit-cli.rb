class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "a5e51d6dff3fdbda740de0aa85257585bbd18c1ab3918fcd6d164c99282c5324"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0c9c8b27ccb4197c85117f73b2e0c4016061cca25402377554f952678551907d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b30e89dd63bfaab1ec9ebbb734f590cc7882de78e75d947c0089e44bf71f892"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f6013bc319de4e8726417165480d689f4bde6ef5046d24762b8b0fe639b0ca9"
    sha256 cellar: :any_skip_relocation, sonoma:         "ad60f9cdc0e931ad39416b44d006b7e68952f5f6e917afd1a238ead6d74162be"
    sha256 cellar: :any_skip_relocation, ventura:        "a43516f4123906801064f7e17911eb83dc1a1eed16c1db0dc243242de872dd40"
    sha256 cellar: :any_skip_relocation, monterey:       "1877b4017f44f55bf15e99b1c86b75e2b829b86643972cc15a7afde67cf8e98d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d8c1e5660fc2154ebe79afd70d9dc7178ffd42964f07e0c00ecd8bff6336e65"
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
