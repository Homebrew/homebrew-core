class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.6/2.6.8/+download/juju-core_2.6.8.tar.gz"
  sha256 "0c5a6ccae09e602621c3958a2c56c0bfa7676060f2169008577b809552af4568"

  bottle do
    cellar :any_skip_relocation
    sha256 "32164113ecacb50bd0d1c9d279ddd813a5230e3879e6db323447c2fd8491cdad" => :mojave
    sha256 "7136831eb565b490ac3720ca7cea5b3902f6847f3247af1893b612aac213bb0f" => :high_sierra
    sha256 "51e05635d54300ae1e9d4d389036d8d8460edd94feb491e6e4967bc42fa61f9c" => :sierra
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
