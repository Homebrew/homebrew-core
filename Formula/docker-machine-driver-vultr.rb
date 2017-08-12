class DockerMachineDriverVultr < Formula
  desc "Docker Machine driver plugin for Vultr Cloud"
  homepage "https://github.com/janeczku/docker-machine-vultr"
  url "https://github.com/janeczku/docker-machine-vultr/archive/v1.4.0.tar.gz"
  sha256 "00fb922126118a7b3e405b888f581fac798a3ebfd175d7f48a1f26d3e115878e"

  head "https://github.com/janeczku/docker-machine-vultr.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "80489b957a4f9be5cf84554d20e46c66e69d0937ebf6e9931ac76fbc715a3379" => :sierra
    sha256 "06322f88994df2318a86b893dad97747b6f40f37c103584f50c17ecc87bea22c" => :el_capitan
    sha256 "1713389722af196c6bdea10fcc45a6859b61718f585e0d514ca812722616ee40" => :yosemite
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
