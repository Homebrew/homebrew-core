class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli"
  url "https://github.com/JFrog/jfrog-cli-go/archive/1.31.2.tar.gz"
  sha256 "a847556ff171475d661329c2e71c3f61774da2ff2f0418fae7d16f5dbed4a70a"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d359e6ced20707b56eccc928248785202033a487d98748d680c4d56a4e5a2403" => :catalina
    sha256 "640dcc93305f1495a93444b89021e432eb4600f8406d13e9d2b264cf83c28207" => :mojave
    sha256 "95b2c2f35547130e0c45e9bd63d9b0db2d50943095b6bbae74832ec079ab47b0" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "run", "./python/addresources.go"
    system "go", "build", "-ldflags", "-s -w -extldflags '-static'", "-trimpath", "-o", bin/"jfrog"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
  end
end
