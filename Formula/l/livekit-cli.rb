class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "66d7080ff5f339f69ddd39a715defc4aaa2f3e5f4d6a1ef815a070b759602c74"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e7b5493d9555798dae623e40de98b63f9d76020313943c0210d143e984537e70"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "316c35350d6f3314ce7bce48014ccdfb0ac06e5b77c45e586da88fea424b75e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0772d69a6408e0180bd66a61eaf5fdf1bb6fcfa7f21c47e9bff4211dd5806b99"
    sha256 cellar: :any_skip_relocation, sonoma:         "34d8737df2ef320f5d315f65de11bb16796257bdc883bc7f728feb569288272d"
    sha256 cellar: :any_skip_relocation, ventura:        "91a113c2447fe31535771d5c96685b84ba537638e976d7ffd4e2532fcd90c762"
    sha256 cellar: :any_skip_relocation, monterey:       "5a9283a1fd0edc12c7f937820bb06018c76c774501bac9d51485a21fdb3d8fbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56700b4194108adbb89ff19a5ab5bc17f1c59b6ecb548b4b760760dd2459c383"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:, output: bin/"lk"), "./cmd/lk"

    bin.install_symlink "lk" => "livekit-cli"
  end

  test do
    output = shell_output("#{bin}/lk token create --list --api-key key --api-secret secret")
    assert output.start_with?("valid for (mins):  5")
    assert_match "lk version #{version}", shell_output("#{bin}/lk --version")
  end
end
