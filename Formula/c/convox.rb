class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/refs/tags/3.24.11.tar.gz"
  sha256 "c71813f9b2dd7d1ddd55d6665dc0c6d55f4235c4a3096d47502aa096b1f356ca"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/convox/convox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "460c66b5c181ad9ed145d4ef026897e166102698631285c7f9910d36d8487a1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14b2bbdbafccb7f66ff0b952cf9d00c297903640252f8a52070ad0db28a479cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66d7d9ccb597f8b1a56629641b70133f87b0d09ad4f338a7e151c6d0c34e635e"
    sha256 cellar: :any_skip_relocation, sonoma:        "8cffbbb1fc2569f8d52571fc7cecf043f7d210112fcba3f23e45c554814213b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4c2d230d6e254730286d17fff76848195866820cc94c438d2b79c67c6391ce8"
    sha256 cellar: :any,                 x86_64_linux:  "ffaf50f84cfeb11cef1b2dd2df11292f5ddf879b4d2f9083edb1eedb033b7177"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "systemd" # for libudev
  end

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", "-mod=readonly", *std_go_args(ldflags:), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
