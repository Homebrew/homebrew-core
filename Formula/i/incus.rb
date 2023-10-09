class Incus < Formula
  desc "CLI client for interacting with Incus"
  homepage "https://linuxcontainers.org/incus"
  url "https://linuxcontainers.org/downloads/incus/incus-0.1.tar.gz"
  sha256 "771b6f438e369f729eaaa6dfd938f14dcc8de09dbc9da23c7c80c6d14f02653b"
  license "Apache-2.0"
  head "https://github.com/lxc/incus.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c4e9c7dbd8c3b31942ca0f56f87692cec4e0113518b72ff3b4443ff9e7673e0d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64c4d604d2d7c488111ea1572a229db957269be5bea4709ba410a388cbbf7813"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e23b7f63e362e8475394697a975d0e7ad16915c1bcc54de825acb18ec22fbb9"
    sha256 cellar: :any_skip_relocation, sonoma:         "cf8ef1ff346fa4aa154b6a086d4359d05a9d9924fa4ff8ff590e89119c32d09d"
    sha256 cellar: :any_skip_relocation, ventura:        "23f65e2f682f3d3e67bbc732cd3290bec8cb1e7dbb129b721b22b86c0780db75"
    sha256 cellar: :any_skip_relocation, monterey:       "0e837f4e8d6865cc31c9c84beeb0cf088f551b6fb3136228191470c5e9fb1dae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5dad3025dc96085fac25504dc1071dfb3dd822292ccbe4e38acf545a1b615d36"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/incus"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/incus remote list --format json"))
    assert_equal "https://images.linuxcontainers.org", output["images"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}/incus --version")
  end
end
