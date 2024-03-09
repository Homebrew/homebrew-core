class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.8.5.tar.gz"
  sha256 "80a162a0b06f531b7bbb56fdd52702879fdcef284ed5583203debbe0ca9c20e8"
  license "AGPL-3.0-only"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "74b3fa9334ae2e7c53e8bee803146a157f566255ddd38b9b3b58aab473539780"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16909aaba673c1e94d4396dace18b38123ebc480d3bf12c42229f38f5940a7df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce9e65436522f70fa67cc82151dc5161326b488a271956fd9088af2f4906aa9a"
    sha256 cellar: :any_skip_relocation, sonoma:         "847b6acb3dfb5f0b51bab16e0963b4416a8d1362573b70eb6a6b50dca17afe1f"
    sha256 cellar: :any_skip_relocation, ventura:        "e546b87700afbfa365628fb23bc55b3228fe9846203c2144792b8ab382ab53a5"
    sha256 cellar: :any_skip_relocation, monterey:       "bfdbed98c03887428f25b96c155480a5bd9b7fc698013559ce9c3a7f70218fb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe7be4565a921f1839a89b5a700fd64c028fac4533132d34e55254de401cdc1c"
  end

  depends_on "go@1.21" => :build # see https://github.com/coder/coder/issues/11342

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "slim", "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end
