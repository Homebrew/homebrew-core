class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/refs/tags/3.21.4.tar.gz"
  sha256 "e37b17f128714f2e87a62bcd988c8e1badc684589e0cdf606317fdfca434bed8"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/convox/convox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a0fe1f07c2b11222c49a8cfd866f3f579e4f28b2e32c3d645d51575d9be211e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80386bbc5b1b8ab8bb845e26d18870db9cfbb8e97fa83591dfff9618e9f1c4c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf61fafe8eb9a77cc05e7dde22bb2fea6991254ae9f2c7337dd55ed0e967a1c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d271130f7dc8e393be423641371bcf17f07d9a49784456fbe90cffe334fff6ce"
    sha256 cellar: :any_skip_relocation, ventura:       "19dfb465c5bff357db4e6a4b52d587f9e54ba0ffc6c24c06649102fbc93f6595"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f7b247db495c3ec37dc631960b759b0f07d00f80143b5f0d9510866359a989f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "195a2997fd18b2d1182fccbccab72734a1843deb0500e87ac9a990238bb9a145"
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
