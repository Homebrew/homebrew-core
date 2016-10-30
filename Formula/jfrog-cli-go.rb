class JfrogCliGo < Formula
  desc "command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/JFrogDev/jfrog-cli-go"
  url "https://github.com/JFrogDev/jfrog-cli-go/archive/1.5.0.tar.gz"
  sha256 "a82f25d0acdd3f7002603cbf0fb0140ebfc43a44cc55a846cf6aecd1a64c58ee"

  bottle do
    cellar :any_skip_relocation
    sha256 "aa9649be99921715d09179083eefe55bdc8d1f12772cc2a30e5953326832c5ef" => :sierra
    sha256 "3ad2ea145f3949675e4e79ffc9accff0ee90ba883fc7e8ac53741232461adc5c" => :el_capitan
    sha256 "ea2bce23173b9b5dc5453ce2261c5bd50b6d454a50573ce3913792802bc7187a" => :yosemite
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
