class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/v2.17.1.tar.gz"
  sha256 "7b56f480166db25c4ef22d1f8c015a4789a6374dcd802d54eebf7b50c516be51"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58fd12f0829cda4acea0bbfa858d48b96b3325506c6fe1b18c0aa3dd38ea756f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3513d59f10cd1532d67ef190e0a8b5120c145c0e8e6e781f9e84c390e7afb7c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ee64da3f62574a6c6a5cf4ddc16600ba5bdf702ad1490c4ee41d7ddf3819904"
    sha256 cellar: :any_skip_relocation, ventura:        "26d91613c841abfa22ca64dff97ba0d2b5afabd119cbba48341ec58a8751624a"
    sha256 cellar: :any_skip_relocation, monterey:       "394b31c9811dc1064df47a4eddb7bbba003821d3fb8f504b413b4bcc04ceb283"
    sha256 cellar: :any_skip_relocation, big_sur:        "279dace05e7c96ba268c6dd37e59e4a1cb5d8fe3d30c542864f79558436b283e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71562cbdb85f68fa5d48c36732b67c0b3791ae82428a77a174b07f7783a26ee0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/docker/compose/v2/internal.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd"
  end

  def caveats
    <<~EOS
      Compose is now a Docker plugin. For Docker to find this plugin, symlink it:
        mkdir -p ~/.docker/cli-plugins
        ln -sfn #{opt_bin}/docker-compose ~/.docker/cli-plugins/docker-compose
    EOS
  end

  test do
    output = shell_output(bin/"docker-compose up 2>&1", 14)
    assert_match "no configuration file provided", output
  end
end
