class JujuAT125 < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju-core/1.25/1.25.8/+download/juju-core_1.25.8.tar.gz"
  sha256 "7866cf4195d7fe87463bc7501cece12b4d0c3d08b8983f66cecf54f6f8b28267"

  bottle do
    cellar :any_skip_relocation
    sha256 "e179401b1e81f898bab0e3e83be72c25a1f894b9354035ddae70380428fb040a" => :sierra
    sha256 "eb2b74644085377a8eca3740b1ee0b209db4324fb7932877dd3d737e60855ee5" => :el_capitan
    sha256 "3358c915bb0f29d699752a29e6bdd1bdb26de8ddb43d452ac01b8ce19f7cf18d" => :yosemite
  end

  depends_on "go" => :build
  conflicts_with "juju@2.0", :because => "juju 1 and 2 cannot be installed simultaneously."

  def install
    ENV["GOPATH"] = buildpath
    system "go", "build", "github.com/juju/juju/cmd/juju"
    system "go", "build", "github.com/juju/juju/cmd/plugins/juju-metadata"
    bin.install "juju", "juju-metadata"
    bash_completion.install "src/github.com/juju/juju/etc/bash_completion.d/juju-core"
  end

  test do
    system "#{bin}/juju", "version"
  end
end
