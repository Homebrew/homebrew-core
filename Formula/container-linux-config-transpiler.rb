class ContainerLinuxConfigTranspiler < Formula
  desc "Convert a Container Linux Config into Ignition"
  url "https://github.com/coreos/container-linux-config-transpiler/archive/v0.5.0.tar.gz"
  homepage "https://github.com/coreos/container-linux-config-transpiler"
  sha256 "172e44796d39ec117584e121e73194cbcb56701407badc1899cea4607a343e15"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "make", "all"
    bin.install "./bin/ct"
  end

  test do
    system "#{bin}/ct", "--help"
  end
end
