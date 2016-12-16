class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/docker.git",
      :tag => "v1.12.5",
      :revision => "7392c3b0ce0f9d3e918a321c66668c5d1ef4f689"

  head "https://github.com/docker/docker.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f14f9346e62b93d0af88d47d2d2d44043b915c38ef5a44e320a3dc882cd68d0c" => :sierra
    sha256 "1549a2b5502389070ea774cc3f054f2755dbb9626e422de8690b101ae3cba844" => :el_capitan
    sha256 "e95f7a368875fde5da2ec738845d54998d5d3df97504070dc173bc389477789a" => :yosemite
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
