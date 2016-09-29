class JfrogCliGo < Formula
  desc "command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/JFrogDev/jfrog-cli-go"
  url "https://github.com/JFrogDev/jfrog-cli-go/archive/1.4.1.tar.gz"
  sha256 "3d2e3850318ddc327ce7c6872452ae16613aece494dbe402d26e743c3b9146ce"

  bottle do
    cellar :any_skip_relocation
    sha256 "34baf782218a4bc0004b14946408c5f9b8f98787cf14bd3f5b48af95febc076e" => :sierra
    sha256 "b7541416601050345c1605f240bfb8c7c702b8356b291d728cb9f7fd3b6c17fa" => :el_capitan
    sha256 "80bdf396140a8853a3869ffd2a2cb835d09611bf332d9ec839ad43ab4ed261b5" => :yosemite
    sha256 "05e723dc49650b6c5a08791afdf5f80ec72bcc2fbae7ec2594aed0ed33a43381" => :mavericks
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
