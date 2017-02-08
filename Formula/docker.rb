class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/docker.git",
      :tag => "v1.13.1",
      :revision => "092cba3727bb9b4a2f0e922cd6c0f93ea270e363"

  head "https://github.com/docker/docker.git"

  bottle do
    rebuild 1
    sha256 "62f05dee992f846622e5292678f502c15e6881a91f90dce5cda3fa5fea5571d9" => :sierra
    sha256 "2d5a37d49f19eeed0169b0d6cc84a2b7e5110a2ebc3eb2fd1701de92d11d8098" => :el_capitan
    sha256 "680e3fb1ee0c54cbd458777b0a9aac2ce2be60a96af740c1053b9f73533957e7" => :yosemite
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
