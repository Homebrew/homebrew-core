class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli-go"
  url "https://github.com/jfrog/jfrog-cli-go/archive/1.16.2.tar.gz"
  sha256 "e6c8813d50d1180787726c8656e74ae5df8be752b51412b407cb0ce2d088fa61"

  bottle do
    cellar :any_skip_relocation
    sha256 "bd5953f911e053189b4dec13f732857a9d4a6eab14ce2114e375a66f2ce7c0a3" => :high_sierra
    sha256 "70875a28c30127a9c97cd1f7055751539cff042abf678890c9ded8cd168e80bd" => :sierra
    sha256 "a5c18ace45a2f8fd9f3f22f7cdff41ec9fdcd8e9a075fcbda384baf5cfcfc2dd" => :el_capitan
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
