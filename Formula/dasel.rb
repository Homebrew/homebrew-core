class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v1.24.3.tar.gz"
  sha256 "86d497e7dcfe63901ef0aeddb31e3989959d60d785a04f98fc6a88b6f497980a"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d847f926532d59d4c341cb1b52ed814ad2facb05b783ddff1da39ce274ca8a76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be5610bcfbe142228787b903afb275bb6cf34cde298e5e8b4a6cd2d4ace73cfe"
    sha256 cellar: :any_skip_relocation, monterey:       "8eabf8630581f24875801946915049e43da4722b2a3e303c23bb57091d94e04c"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c369a3739e2446f1d33917626f436286e88355ff52ade0b54e951ea56d8cdd8"
    sha256 cellar: :any_skip_relocation, catalina:       "c2d969cf7cf64481e5bd30db2dfcda2d858582c5cff0ce07083d79dad54d348b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a7d819d8471b4243fb7c01c276c587da39bfbae2db45543bdfc46aede23853f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X 'github.com/tomwright/dasel/internal.Version=#{version}'"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/dasel"
  end

  test do
    json = "[{\"name\": \"Tom\"}, {\"name\": \"Jim\"}]"
    assert_equal "Tom\nJim", pipe_output("#{bin}/dasel --plain -p json -m '.[*].name'", json).chomp
  end
end
