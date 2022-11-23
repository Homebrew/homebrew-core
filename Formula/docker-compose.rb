class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/v2.13.0.tar.gz"
  sha256 "b24ca9b04ad511412af6595a7c3d6a3c119c920b7429545b4e6f70be07523007"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c31b51fa7366371b248629265ba6111f19b144c643b96b74e3110fc91a4ba3d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c31b51fa7366371b248629265ba6111f19b144c643b96b74e3110fc91a4ba3d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c31b51fa7366371b248629265ba6111f19b144c643b96b74e3110fc91a4ba3d4"
    sha256 cellar: :any_skip_relocation, ventura:        "3afd42776a41dd1ad5fbfe99e2fc09ebda077ea83ef08a31f9fb2f1a173b1e07"
    sha256 cellar: :any_skip_relocation, monterey:       "5b797a67934a1c2cd7eb82ce10f891d4232729d457372a6d67ebb782565398d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b797a67934a1c2cd7eb82ce10f891d4232729d457372a6d67ebb782565398d5"
    sha256 cellar: :any_skip_relocation, catalina:       "5b797a67934a1c2cd7eb82ce10f891d4232729d457372a6d67ebb782565398d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1deb76b530921a70d6d097511d12f6de4ebb02cc31bf62b089d1e1a27b5470e0"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
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
