class JfrogCliGo < Formula
  desc "command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/JFrogDev/jfrog-cli-go"
  url "https://github.com/JFrogDev/jfrog-cli-go/archive/1.4.0.tar.gz"
  sha256 "c303147e7286f719e958a68d816cd455919b79bf312ac9cc8f32f9c0f1403ce4"

  bottle do
    cellar :any_skip_relocation
    sha256 "57b015e52ac0dee9f7a9e6a68102dd15a305ebad3dc1e7878489c1a7a23d9ffb" => :el_capitan
    sha256 "2940e510fc263eff5c4477df44f8b4fa9442baef8b55e3655594453de488c912" => :yosemite
    sha256 "bba05725a4c3386fbcd5e950f6fef888537f7ea59588fbbb32e7d2cd552b7ad6" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/jfrogdev/jfrog-cli-go").install Dir["*"]
    cd "src/github.com/jfrogdev/jfrog-cli-go" do
      system "go", "build", "-o", bin/"jfrog", "jfrog/main.go"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
  end
end
