class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/JFrogDev/jfrog-cli-go"
  url "https://github.com/JFrogDev/jfrog-cli-go/archive/1.10.1.tar.gz"
  sha256 "d6a8ad0af6006d0d5074187eddc91daef740d2430cdeddb623718f45e6f4ec6d"

  bottle do
    cellar :any_skip_relocation
    sha256 "0038ba900bd37fa2f1e47ec7c4b1b470c659973aa708a7e78aa4b3f6591e642b" => :sierra
    sha256 "fd15d1d70fe8da48d4deb28ac2f8b13528ed77e28e6a4eb550f3a14fd6fc6baf" => :el_capitan
    sha256 "0dd63020b6facfeaf3930eee9889d24efc8ca5d90d474cbcd9f775b6d1a3438d" => :yosemite
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
