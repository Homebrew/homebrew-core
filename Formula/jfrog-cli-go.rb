class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/JFrogDev/jfrog-cli-go"
  url "https://github.com/JFrogDev/jfrog-cli-go/archive/1.11.2.tar.gz"
  sha256 "b57f85205097c194d23dae07b225b492839ddf941e0711e7ebdc3e44b13d195d"

  bottle do
    cellar :any_skip_relocation
    sha256 "fb9fc475d7d34819457bf39cb603f54f4380d141de4ed717809bb9d5ce59173c" => :high_sierra
    sha256 "5dc4b44fe551cbb4072bc70a2cf1598a96c9dc473fa302921b209df3f7e22cfc" => :sierra
    sha256 "12050253039e317f84416cc3cdac9c9142065d62697f2bf3b753b381d977e360" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/jfrogdev/jfrog-cli-go").install Dir["*"]
    cd "src/github.com/jfrogdev/jfrog-cli-go" do
      system "go", "build", "-o", bin/"jfrog", "jfrog-cli/jfrog/main.go"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
  end
end
