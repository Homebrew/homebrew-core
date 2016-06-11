require "language/go"

class JfrogCliGo < Formula
  desc "command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/JFrogDev/jfrog-cli-go"
  url "https://github.com/JFrogDev/jfrog-cli-go/archive/1.3.1.tar.gz"
  sha256 "4684813c256e8124623fdcb5089606cc425862fce7dbb8ed4f7e18b1debd297e"

  bottle do
    cellar :any_skip_relocation
    sha256 "4980e5307f2d1d68a56d8566588a8abd14eae67a5e3f45d475436e152c73fdd3" => :el_capitan
    sha256 "6c2056e9c7541a6dbf94478d325b5b49a5c367c1eb870fb0ad1f6b932890a578" => :yosemite
    sha256 "1c6962b9ce1f3dc325529fc84258b839c7e745b66e9362394ddecdef7af355bf" => :mavericks
  end

  depends_on "go" => :build

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
    :revision => "c197bcf24cde29d3f73c7b4ac6fd41f4384e8af6"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/JFrogDev/").mkpath
    ln_sf buildpath, buildpath/"src/github.com/JFrogDev/jfrog-cli-go"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "#{bin}/jfrog", "github.com/jfrogdev/jfrog-cli-go/jfrog"
  end

  test do
    assert_equal "jfrog version 1.3.1", shell_output("#{bin}/jfrog -v").chomp
  end
end
