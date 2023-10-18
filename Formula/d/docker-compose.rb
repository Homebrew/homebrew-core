class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/refs/tags/v2.22.0.tar.gz"
  sha256 "82bd4622729cff061b3489bad96b54849a7f4b462345aade1bd374c879db9019"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f16358437f0b28e25618d82312eeb9746058fac437ec1c95334ea09863690015"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cae5535b7aba746248ba4d224c3cf1de6c8414b8ee74f15e536674742739e27e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fbb3bf9c7be9945b680cbd2653de77fe1bc4a0e8776cce353b2ca3faadfc705"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a56d1132fbabdfae12250adaa1e205a3b5db49566c027657af679765ef586b10"
    sha256 cellar: :any_skip_relocation, sonoma:         "ebc0f40840e59470db7a4b5b35e663c7ccc519f2b02689bf8f77d98755ecff87"
    sha256 cellar: :any_skip_relocation, ventura:        "62da9fbcd40cdd3c9e621932f69ad31b13079c7991f4ee7857237e5532f7ad67"
    sha256 cellar: :any_skip_relocation, monterey:       "4ba1d0af96faf222109722eb1f989627da4aa9da4f0479f92ca9bed35ce2a69e"
    sha256 cellar: :any_skip_relocation, big_sur:        "2588a6c93cb01dc63433ee3c8f3297520f725b5bb7523706f2c21cf1c5c6bfb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "872ecb1756abd50c3fd31cfd405a152d460de060eec9d2710a09024b932b9cbb"
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
