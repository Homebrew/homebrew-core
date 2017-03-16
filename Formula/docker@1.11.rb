class DockerAT111 < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/docker.git",
      :tag => "v1.11.2",
      :revision => "b9f10c951893f9a00865890a5232e85d770c1087"

  head "https://github.com/docker/docker.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "900e30f27b73f3fdd7a7e08060ceb8788e242b050334f34f32c20d4fcb19e5b6" => :sierra
    sha256 "395b70bc1a528d4615faa940c63eecdbfffd564821de4df0d0f121c4bf41fa68" => :el_capitan
    sha256 "e8c7a80898ad0ea1eac2a2b373135b0abf9e5077c48d5cd8285313447be71df9" => :yosemite
  end

  keg_only :versioned_formula

  option "with-experimental", "Enable experimental features"
  option "without-completions", "Disable bash/zsh completions"

  depends_on "go" => :build

  if build.with? "experimental"
    depends_on "libtool" => :run
    depends_on "yubico-piv-tool" => :recommended
  end

  def install
    ENV["AUTO_GOPATH"] = "1"
    ENV["DOCKER_CLIENTONLY"] = "1"
    ENV["DOCKER_EXPERIMENTAL"] = "1" if build.with? "experimental"

    system "hack/make.sh", "dynbinary"

    build_version = build.head? ? File.read("VERSION").chomp : version
    bin.install "bundles/#{build_version}/dynbinary/docker-#{build_version}" => "docker"

    if build.with? "completions"
      bash_completion.install "contrib/completion/bash/docker"
      fish_completion.install "contrib/completion/fish/docker.fish"
      zsh_completion.install "contrib/completion/zsh/_docker"
    end
  end

  test do
    system "#{bin}/docker", "--version"
  end
end
