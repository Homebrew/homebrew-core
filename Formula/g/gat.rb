class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://github.com/koki-develop/gat/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "62c7509bee419f81af5d2f856f17ec98d65dd12212b3e361806cb2b6a22233b6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "010f940992f91c1d91214c402f313708946590c23a5644fb59d467a31664e59c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ab789c3095f28c57deebd968b2e11f44554ec85c10a1c995411f8ce26ca17d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50e3103d1c34a69fbf5f503ad21504db6ea146534116a3d0c642847b7a190b16"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ba2edc8d1f0002e25cebd7fca6c8ede28517424f0f60e2de7878857e89e6ea4"
    sha256 cellar: :any_skip_relocation, ventura:        "557043aba542faa00d973bfe1b29379ea0ee1d792d0652554ccecb712b466aa1"
    sha256 cellar: :any_skip_relocation, monterey:       "6dcafe3008794a5d26a0c01a235d9352042ba02fb418e8ba3379af657d4e2831"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6189dfc425f90bbfd7a349f639bd238cff90a814eb23fb25ba305cb3bcc40b3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/koki-develop/gat/cmd.version=v#{version}")
  end

  test do
    (testpath/"test.sh").write 'echo "hello gat"'

    assert_equal \
      "\e[38;5;231mecho\e[0m\e[38;5;231m \e[0m\e[38;5;186m\"hello gat\"\e[0m",
      shell_output("#{bin}/gat --force-color test.sh")
    assert_match version.to_s, shell_output("#{bin}/gat --version")
  end
end
