class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.4.3.tar.gz"
  sha256 "9f2de7fbfb7e0e868afe0e02b854712bb563f84d1936390f826506f719ccccd5"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "075d01f8fbbf32ba516f03764281683fb466c1d25b86c5d0f3e0ef745eaffa01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f79c4be6ada316249ed39fa1593e2e06db0d9b06c174dea72b3e2d8be0abdc08"
    sha256 cellar: :any_skip_relocation, monterey:       "6afaf769f1bb465087f372fe0b9938ff855c6f100ca4813f7a566ec2f5e7fc42"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0118ac41f0ee003b26c9a8a624d65ae390e50e705c62e62742625b4b8fdd9b5"
    sha256 cellar: :any_skip_relocation, catalina:       "baa3fd343d06922d0d4cfef36690a69ef8ad548af98011e991942a6dda564d14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d92a847c34ea5fa71084df591e05242cbc2d1659d330bb46663f3e211da009c7"
  end

  depends_on "go" => :build

  # Support go 1.17, remove when upstream patch is merged/released
  # https://github.com/convox/convox/pull/389
  patch do
    url "https://github.com/convox/convox/commit/d28b01c5797cc8697820c890e469eb715b1d2e2e.patch?full_index=1"
    sha256 "a0f94053a5549bf676c13cea877a33b3680b6116d54918d1fcfb7f3d2941f58b"
  end

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags: ldflags), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
