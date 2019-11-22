class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli"
  url "https://github.com/JFrog/jfrog-cli-go/archive/1.30.4.tar.gz"
  sha256 "5a97e3eb2b53e2ee71851730fefd6094f3954a955ec47dee7d9349d31eb7de6c"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec56c1e2b1fa1f2b837ba8d0abed856343db3c1f058814e4ccfabb447ebb5b77" => :catalina
    sha256 "0f348458539931885a3e0e6e90553e71bf9a3f4a081c67586e80bb89f7baa9c3" => :mojave
    sha256 "9a6286a7bb0e9bf96c3565bbcf8b3c16f7a9e6b90c5489184487d9936eeae17a" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    src = buildpath/"src/github.com/jfrog/jfrog-cli"
    src.install buildpath.children
    src.cd do
      system "go", "run", "./python/addresources.go"
      system "go", "build", "-o", bin/"jfrog", "-ldflags", "-s -w -extldflags '-static'"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
  end
end
