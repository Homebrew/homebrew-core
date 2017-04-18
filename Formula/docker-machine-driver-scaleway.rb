require "language/go"

class DockerMachineDriverScaleway < Formula
  desc "Docker Machine driver for Scaleway"
  homepage "https://github.com/scaleway/docker-machine-driver-scaleway/"
  url "https://github.com/scaleway/docker-machine-driver-scaleway/archive/v1.0.1.tar.gz"
  sha256 "90caba19fa78bd5c6e01c0696ff37eb9d877cb252ae37dacc63ffde86a3cbe7a"

  head "https://github.com/scaleway/docker-machine-driver-scaleway.git"

  depends_on "go" => :build
  depends_on "docker-machine" => :recommended

  def install
    ENV["GOPATH"] = buildpath
    path = buildpath/"src/github.com/scaleway/docker-machine-driver-scaleway"
    path.install Dir["{*,.git,.gitignore}"]

    cd path do
      system "go", "build", "-o", "#{bin}/docker-machine-driver-scaleway", "./main.go"
    end
  end

  test do
    output = shell_output("#{Formula["docker-machine"].bin}/docker-machine create --driver scaleway -h")
    assert_match "scaleway-name", output
  end
end
