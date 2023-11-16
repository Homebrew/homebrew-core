class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/refs/tags/v2.23.1.tar.gz"
  sha256 "9b4fba785b09d6745c35fff440cf5e2ce80bf7216dcb048535a7761dec492d11"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc328bc12b385a65fee99b2ce3489b9dee204557276e10bc095ce418095a008b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36fe70dfb14752cd6bbef69e8cb83c9b83084e02355c5d8c57809a55c238be70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d93aaf8bd026fa92298d15d85dce2aec363ec932482ebec63883bdcabbe6e967"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe175ca309b626387cf913765aa06a12df929b5fd2b88c0af90b5a25530b825a"
    sha256 cellar: :any_skip_relocation, ventura:        "b0e70fc1e04d1f1943244a198fc32654bc004e919b784fc51b46b2666941af94"
    sha256 cellar: :any_skip_relocation, monterey:       "d357bea60b0268f00ac25834787e905ef9461b1b40ec2ed83e7809d74e96e9fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fec6b3d802fd469c8322116c137de52d75f70a9ebe518705efcb3647814f6ba7"
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
