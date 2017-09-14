class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.2/2.2.4/+download/juju-core_2.2.4.tar.gz"
  sha256 "e94ffefe04a4e8039944a845778cbb0bc1e0e11cd758c669ff4e19173350044c"

  bottle do
    cellar :any_skip_relocation
    sha256 "a2a2e770001b7db81d3dea322c9cf8c510dbf07fa1f46340bd640b88f604b857" => :sierra
    sha256 "c87c4caa1b163d1771156965df2d7946bf9626118dc85eec868f3f052060dfa6" => :el_capitan
    sha256 "78ce938cd2e254c2dfa4d1d20af2ea15faeda94697c43012e6bc91856a7750fd" => :yosemite
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
