class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.4/2.4.2/+download/juju-core_2.4.2.tar.gz"
  sha256 "1c30acb607cf29ffc766ff4a832df2b52addaa6fe1bbc28e2ef94e19533a7e7a"

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
