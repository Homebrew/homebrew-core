class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/docker.git",
      :tag => "v17.03.1-ce",
      :revision => "c6d412e329c85f32a4b2269b49aaa0794affcf88"

  head "https://github.com/docker/docker.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e671657e8982685d105bc9d81d71c94c22010ae0f0c120ac79fadde87753e517" => :sierra
    sha256 "98131a038b9b8f4742f0db6ef2b1bb82cfa24f6022e02452ebebb882eacd3b9f" => :el_capitan
    sha256 "4535b7f05f77e434110b4366facd8c0b3e9d7657a9410596271395b6fb65ba52" => :yosemite
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
