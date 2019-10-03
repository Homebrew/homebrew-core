class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.6/2.6.9/+download/juju-core_2.6.9.tar.gz"
  sha256 "85c428a6c558432d24b9d29011f62fc2ed46961933cb3cbb5aba85cb9768a00c"

  bottle do
    cellar :any_skip_relocation
    sha256 "b65c4001d14903681602f80a625576323fa9786d57d444400776b66bafa0a043" => :catalina
    sha256 "303e828a56d5c524bd42ce34231f85a2868a62fb7bee07e0eca44e35f4dc9495" => :mojave
    sha256 "ad7e93a9fe152bbcd614b2ccdc6887174f64a1db867b2dd6764f51399d88b2a9" => :high_sierra
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
