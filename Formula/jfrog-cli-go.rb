require "language/go"

class JfrogCliGo < Formula
  desc "command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/JFrogDev/jfrog-cli-go"
  url "https://github.com/JFrogDev/jfrog-cli-go/archive/1.1.0.tar.gz"
  sha256 "62550b0f544cc0e814b1c9b1bf96999152fd79f1fe981f755a2ec71f4acae4ef"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "4bc2bed7d7bce710fc0279a9f7d6eeb6514a3a060d81d6875c50e6f059ff627d" => :el_capitan
    sha256 "b2f04248ecdb95cabec6dca51b1e0d6c96b026d327efb3f2999439c064fcb031" => :yosemite
    sha256 "eba7de045f256ac8f079b33ed4d891b6551636ac4aae88cf586cd2dc3639ae0b" => :mavericks
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
    actual = pipe_output("#{bin}/jfrog -v")
    expected = "jfrog version 1.1.0\n"
    assert_equal expected, actual
  end
end
