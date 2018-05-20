class DockerMachineIpconfig < Formula
  desc "Manipulate docker-machine network interface settings"
  homepage "https://github.com/fivestars/docker-machine-ipconfig"
  url "https://github.com/fivestars/docker-machine-ipconfig.git",
    :tag => "v1.0.0"

  depends_on "docker-machine" => :recommended

  def install
    bin.install "docker-machine-ipconfig"
  end

  test do
    assert_match "Usage: docker-machine-ipconfig", shell_output(bin/"docker-machine-ipconfig --help")
  end
end
