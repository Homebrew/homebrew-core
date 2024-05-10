class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https://hoverfly.io/"
  url "https://github.com/SpectoLabs/hoverfly/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "50978ef55fa22311b2d444d228fc9d96a29249f9e3cd40a3246354828ea033c6"
  license "Apache-2.0"
  head "https://github.com/SpectoLabs/hoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f503b82433c0bf68b2dc6b02d61b9a1b3cc1f0ac3bc95867ca137967c9f2e000"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "358fd2ebaeb70dd9e32b2ecd29737d01dec5339490e83ccc558acfed5e7657da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96db4324a60749e528977602ebd2f41a73acf93a2b3abca231049875082a9eb7"
    sha256 cellar: :any_skip_relocation, sonoma:         "742bf4a9874a907b05fc27af4feffeb140cd541cc44da9582b0ee6a1c7b2981c"
    sha256 cellar: :any_skip_relocation, ventura:        "74ff65d27789216a03042c019c731e8d40974852fe5ffc737759074a8be2cec5"
    sha256 cellar: :any_skip_relocation, monterey:       "7be20cc09583adea66e9f447d786ed49f784dc1891d57cf7f8853414857b4eaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "247f2fd966e656eeb9ef4c19bbbc19672c0c8d2a2c77042e94466d30c3c9f51b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.hoverctlVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./core/cmd/hoverfly"
  end

  test do
    require "pty"

    stdout, = PTY.spawn("#{bin}/hoverfly -webserver")
    assert_match "Using memory backend", stdout.readline

    assert_match version.to_s, shell_output("#{bin}/hoverfly -version")
  end
end
