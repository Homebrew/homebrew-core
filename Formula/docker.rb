class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/docker.git",
      :tag => "v17.05.0-ce",
      :revision => "89658bed64c2a8fe05a978e5b87dbec409d57a0f"

  head "https://github.com/docker/docker.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d60ad4d00efd0d0358a93fe19d91ce155a37a184e4a98b29e74a215d17497b26" => :sierra
    sha256 "7faaea79928b474f1f01fcca3864fa1effe49c9f3519279555f88e97310d5852" => :el_capitan
    sha256 "7f9827b8ff928e62e49a76a1d2a3d35a3c5b2b2319db9d83f560742415700dd4" => :yosemite
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

    build_version = build.head? ? File.read("VERSION").chomp : "#{version}-ce"
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
