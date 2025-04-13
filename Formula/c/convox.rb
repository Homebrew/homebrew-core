class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/refs/tags/3.21.0.tar.gz"
  sha256 "8959ccff21f2d8fc57a042cca09634ee84a786801d914406f1046d3bdbc014a7"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/convox/convox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5be6c21322c6368fd50bc21e1b2d09148bc511169849d593392450899ae2e30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a14ac8ecc9185df44afa5f5130e8c6a8bb5140de275869456678874d10d04945"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "170f0a71994194e04d7d3d48f28eee3c158d53dcbc6b558f00e825a26af3b818"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b2ef44c6d6c05c9800e6b00b377979e5bce72d6102c6e25efc932f004315427"
    sha256 cellar: :any_skip_relocation, ventura:       "c47cee9fce21b98f68c6a5c5b8f5b1f7c3c06b296eb4265346534927c0880e51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a4a355e6812f83445830de1179b15ec5f219492636701becd61c48538955d9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a7d7bb66bdf5621adc348598c1e487a2de6bd8da47c328165f2dbe618f6b9a2"
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
