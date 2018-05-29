class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.3/2.3.8/+download/juju-core_2.3.8.tar.gz"
  sha256 "e92bb93b47c9dcd9ab3afb7d3efde43ad244140c373ffec71c7140e54f0828ca"

  bottle do
    cellar :any_skip_relocation
    sha256 "b73101a02c96138773cb59af9c484a42ed63d5bd09a6b62cf98e3e359c0f7515" => :high_sierra
    sha256 "8326712b225ad7ba69761afc9041981a18cd422fee115186b24dec3c1ed261ae" => :sierra
    sha256 "5509e23df5cb99c21da48239ed862458144fa1d1130ebf79a48cd751b627da24" => :el_capitan
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
