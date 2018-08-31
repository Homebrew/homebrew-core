class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.4/2.4.3/+download/juju-core_2.4.3.tar.gz"
  sha256 "e956d6ce8922add2c40aa0edf81a55aaa0e9cc9adef7876d52705975c4e3a4a3"

  bottle do
    cellar :any_skip_relocation
    sha256 "54791eaa7e0d5018848f6a6a8794afb4a2e23c25b17d8ea762ea7366b4e36dbc" => :high_sierra
    sha256 "d26a3c9599db7927f97224d8d5907c27f7a2944fcc76c4583f181e371dbb14bc" => :sierra
    sha256 "d24f8217221a2eaedd5799be0655683c141f6dfcf1d88af641187e55d24af1ca" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "go", "build", "github.com/juju/juju/cmd/juju"
    system "go", "build", "github.com/juju/juju/cmd/plugins/juju-metadata"
    bin.install "juju", "juju-metadata"
    bash_completion.install "src/github.com/juju/juju/etc/bash_completion.d/juju"
  end

  test do
    system "#{bin}/juju", "version"
  end
end
