class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/refs/tags/3.18.3.tar.gz"
  sha256 "ea29f66ee021114bf938ef1f7611d23b43266cbc1e40b16303f8979e89c8c333"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5060db86cddd8106b4297951f89f5a280eb3e0b1b8f59c875da65788815a305f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4040623d98fdc9a5a97db7b5a6ae4291224f7c2c9f74528111fb94acf072b4f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bce6516969a6913a48e7c9ac9485fe81045b84684ed76f2af7d2c64d99e1ffe"
    sha256 cellar: :any_skip_relocation, sonoma:         "57b17033cd94545b1036534312b249c205252cd97169ac5df13aa7d8a13dadd6"
    sha256 cellar: :any_skip_relocation, ventura:        "21ee923ad0580cbe6effd69ba728932e6de4f1f61a10715b3acef8f1932b3851"
    sha256 cellar: :any_skip_relocation, monterey:       "1cbe7a276298b96f67e69dc376b3f89e177851ffa9853f85e2ac212538baaf57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56c70807191a8cff963f1cd3cea431df619c34ca4267e1255f2c97928e94b070"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags:), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
