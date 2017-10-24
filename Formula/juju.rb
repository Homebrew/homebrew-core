class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.2/2.2.5/+download/juju-core_2.2.5.tar.gz"
  sha256 "e3ceb690a89316a9cd98ced6046d23ed578ede1af42a1a6d108a5e2594778297"

  bottle do
    cellar :any_skip_relocation
    sha256 "7e527d03baf459518400506861ffde2ac8834e6669d43419e8dda4b680b9e146" => :high_sierra
    sha256 "f15cfbc571b78cd88235464a30f1627128a2e2f11a2038d07ca7ec912fb95701" => :sierra
    sha256 "cb02ef1bbce63a59f9b2eea466d99b582a44aa7afc60dd5a07df1d381558222e" => :el_capitan
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
