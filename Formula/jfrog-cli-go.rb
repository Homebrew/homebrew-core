class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli"
  url "https://github.com/JFrog/jfrog-cli-go/archive/1.33.1.tar.gz"
  sha256 "0960f073991dd2e754ee3809f6c371529de90399f2acdfc3c507dbdc9717d1e6"

  bottle do
    cellar :any_skip_relocation
    sha256 "6a8e1c2b31e053b1318cfda7e4ee5c75fcd331b4cc1fce0d6189e04528f1026c" => :catalina
    sha256 "1e2a27654d759f9ab271c56caa14ae062d5c21e1f45cbb2be957a1eaf85025fb" => :mojave
    sha256 "60845059f75887c663a6f61f2e004e812493bc24cdeb6f1d0a8bea4aa5887110" => :high_sierra
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
