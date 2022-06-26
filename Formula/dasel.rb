class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v1.25.0.tar.gz"
  sha256 "49f7a34b31c87d27ef5c5a32b87a603ac6d7d4d1a52533942676429b747e1f7e"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c995601547782c77e85eafd21bf14ada71ee1841eb38640154c4548be50d14f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c94d4c79cb73e16df67e4eeb565a4953baea12c606f159fe2c2e968e4ff701ca"
    sha256 cellar: :any_skip_relocation, monterey:       "3d45db1036ece790e2320d9b38d8b1ba5ad9435026fe593f36bb97cd3a789a81"
    sha256 cellar: :any_skip_relocation, big_sur:        "497f0d5b87efe8934b844caa49278dffae5de0f67063fc4dc0c99d0d56c6cb2a"
    sha256 cellar: :any_skip_relocation, catalina:       "9a7341e4279919d1f390dfbb386c86d5ce991a0d81d4ed5e661e40c5d7ad2119"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0b917d73e21964aa438c0782be7aa4975a967f7020b4b9a6be95f9da8715b2b"
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
