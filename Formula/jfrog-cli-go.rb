require "language/go"

class JfrogCliGo < Formula
  desc "command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/JFrogDev/jfrog-cli-go"
  url "https://github.com/JFrogDev/jfrog-cli-go/archive/1.3.0.tar.gz"
  sha256 "e9796b628b891d51b9a84ad45ddb30c04a033760aaae3af6563256e79e27acb5"

  bottle do
    cellar :any_skip_relocation
    sha256 "9f569aadeb960f99595303b5c9031af600024eeaaca734d6b1b6b7ae5624fb68" => :el_capitan
    sha256 "178343e4d3b291eff0cbbb399cc39f0db5496fe15767812fbd4470b8d48e058d" => :yosemite
    sha256 "9f68bbe27f7b0160e185ccf03f714de2cb84ea389976fabfd0eac55125f8b567" => :mavericks
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
    assert_equal "jfrog version 1.3.0", shell_output("#{bin}/jfrog -v").chomp
  end
end
