class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/docker.git",
      :tag => "v1.13.0",
      :revision => "49bf474f9ed7ce7143a59d1964ff7b7fd9b52178"

  head "https://github.com/docker/docker.git"

  bottle do
    sha256 "468bfeed9b8d032b47833ef69c60abf214a5397564d510a1769c4fac7f180d9b" => :sierra
    sha256 "f9ca0a0c2cb93564c01852200bf46f31ff9cce1248990a8ab19d591386062e22" => :el_capitan
    sha256 "93af3ca7dbf140adc7060539a24a002870fd015527022a47e76fad28fbc18f98" => :yosemite
  end

  option "with-experimental", "Enable experimental features"
  option "without-completions", "Disable bash/zsh completions"

  depends_on "go" => :build

  if build.with? "experimental"
    depends_on "libtool" => :run
    depends_on "yubico-piv-tool" => :recommended
  end

  def install
    ENV["AUTO_GOPATH"] = "1"
    ENV["DOCKER_EXPERIMENTAL"] = "1" if build.with? "experimental"

    system "hack/make.sh", "dynbinary-client"

    build_version = build.head? ? File.read("VERSION").chomp : version
    bin.install "bundles/#{build_version}/dynbinary-client/docker-#{build_version}" => "docker"

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
