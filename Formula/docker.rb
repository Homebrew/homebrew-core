class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/docker.git",
      :tag => "v1.12.1",
      :revision => "23cf638307f030cd8d48c9efc21feec18a6f88f8"

  head "https://github.com/docker/docker.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "05fdec6a538d2cb0c0a12f1f207c154d92d23ca43d3b7eebf3b6369100c3e008" => :sierra
    sha256 "4ffcf511d6112e05dd95fe133b73fbe1ae9817f43c50114122c5526d181be847" => :el_capitan
    sha256 "25f86c6eaa197b0125d7685bba66cdde29ddf5a3c958bdd5df1f43b0451ea3f1" => :yosemite
    sha256 "233c9d482a262bed39d47fa410751f9278e3015fa01e8c96cc3ab4c9f51dcd25" => :mavericks
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
