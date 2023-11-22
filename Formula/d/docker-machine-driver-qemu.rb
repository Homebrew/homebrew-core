class DockerMachineDriverQemu < Formula
  desc "Docker machine driver for pure qemu/kvm - no libvirt"
  homepage "https://github.com/machine-drivers/docker-machine-driver-qemu"
  url "https://github.com/machine-drivers/docker-machine-driver-qemu/archive/0324171328f7bdf2f1e7803dbdc3b18db457c786.tar.gz"
  sha256 "704f05e967d8c5ad9c42120acacb2dff7d3de949c0649a7aaff87beae3fa9afc"
  license "Apache-2.0"

  depends_on "go" => :build
  depends_on "docker-machine"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd"
  end

  test do
    assert_match "--qemu-boot2docker-url",
      shell_output("#{Formula["docker-machine"].bin}/docker-machine create --driver qemu -h")
  end
end
