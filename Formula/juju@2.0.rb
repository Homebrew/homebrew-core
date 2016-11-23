class JujuAT20 < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.0/2.0.1/+download/juju-core_2.0.1.tar.gz"
  sha256 "af5d59f4b4508c3f81b15fe052fe377876f5de845885d6d41d054f4ac605b9e9"

  depends_on "go" => :build
  conflicts_with "juju@1.25", :because => "juju 1 and 2 cannot be installed simultaneously."

  def install
    ENV["GOPATH"] = buildpath
    system "go", "build", "github.com/juju/juju/cmd/juju"
    system "go", "build", "github.com/juju/juju/cmd/plugins/juju-metadata"
    bin.install "juju", "juju-metadata"
    bash_completion.install "src/github.com/juju/juju/etc/bash_completion.d/juju-2.0"
  end

  test do
    system "#{bin}/juju", "version"
  end
end
