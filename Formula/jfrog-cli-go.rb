class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli-go"
  url "https://github.com/jfrog/jfrog-cli-go/archive/1.18.0.tar.gz"
  sha256 "ff47adaa9b033fe43da5c165481cbaf216ab0f0714e8f23b8b3a81be3fdb2b5e"

  bottle do
    cellar :any_skip_relocation
    sha256 "701e07f9211a700db34ff1fba6f9e40b7e13cae79aaa6e1d8c040e43bc543a20" => :high_sierra
    sha256 "62552da4db3877339ec56901707fdb393e8ec499c21c05222aef63c2b595d6d6" => :sierra
    sha256 "37b0a6ce7d32cacffdf89cda492247fdc8d898b404760b261ac2eb7acff0fa66" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/jfrog/jfrog-cli-go").install Dir["*"]
    cd "src/github.com/jfrog/jfrog-cli-go" do
      system "go", "build", "-o", bin/"jfrog", "jfrog-cli/jfrog/main.go"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
  end
end
