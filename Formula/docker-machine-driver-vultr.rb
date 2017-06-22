class DockerMachineDriverVultr < Formula
  desc "Docker Machine driver plugin for Vultr Cloud"
  homepage "https://github.com/janeczku/docker-machine-vultr"
  url "https://github.com/janeczku/docker-machine-vultr/archive/v1.2.2.tar.gz"
  sha256 "c22e63d832aaa750c70bce5e31655a1c113ba7e75819170b31c2973e0c924e6c"

  head "https://github.com/janeczku/docker-machine-vultr.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec610463d4f1920712c203e11fed4a761d6962315f0ac08d06d0b1c34ab8a5bd" => :sierra
    sha256 "d6880593f426c0bedd0d8bed2bf45077e1f1edb903c47516581a80c789d1d2a2" => :el_capitan
    sha256 "64a72eb914d5f56a700ebed4e2d4ae9e3aeaa7a5ae9deb28fb033b00b3cae63b" => :yosemite
  end

  depends_on "go" => :build
  depends_on "godep" => :build
  depends_on "docker-machine" => :recommended

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/janeczku/docker-machine-vultr").install buildpath.children

    cd "src/github.com/janeczku/docker-machine-vultr" do
      system "make"
      bin.install "build/docker-machine-driver-vultr-v#{version}" => "docker-machine-driver-vultr"
    end
  end

  test do
    assert_match "--vultr-api-endpoint",
      shell_output("#{Formula["docker-machine"].bin}/docker-machine create --driver vultr -h")
  end
end
