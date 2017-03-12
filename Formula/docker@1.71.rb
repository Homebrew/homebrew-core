class DockerAT171 < Formula
  desc "The Docker framework for containers"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/docker.git",
      :tag => "v1.7.1",
      :revision => "786b29d4db80a6175e72b47a794ee044918ba734"

  bottle do
    cellar :any_skip_relocation
    sha256 "1b0c6d26c4242e328f82dfb00d3cd788fbcf58986d71ff62647f1459e9136dbd" => :sierra
    sha256 "c826383171425a87bb42fa0a83f590465a79f76fb8992b970efafb04cc0565a2" => :el_capitan
    sha256 "e84c670e21f03563bbff047bff3a6925933f094015cb51ad2c461183c32f19d3" => :yosemite
  end

  keg_only :versioned_formula

  option "without-completions", "Disable bash/zsh completions"

  depends_on "go" => :build

  def install
    ENV["AUTO_GOPATH"] = "1"
    ENV["DOCKER_CLIENTONLY"] = "1"

    system "hack/make.sh", "dynbinary"
    bin.install "bundles/#{version}/dynbinary/docker-#{version}" => "docker"

    if build.with? "completions"
      bash_completion.install "contrib/completion/bash/docker"
      zsh_completion.install "contrib/completion/zsh/_docker"
    end
  end

  test do
    system "#{bin}/docker", "--version"
  end
end
