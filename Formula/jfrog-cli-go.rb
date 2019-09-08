class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli"
  url "https://github.com/jfrog/jfrog-cli/archive/1.28.0.tar.gz"
  sha256 "b0018994ad68fb7e6ed3938f291b3babfb3d0e975c4c5b18b9e097b8d97b84e3"

  bottle do
    cellar :any_skip_relocation
    sha256 "f1731cffe164adeda93e5c80ebe135a632eefdbba159ce54c2e1dd034f69db00" => :mojave
    sha256 "7bed88d7a09059f5c34300f5cd44954e41c5ed6e0508ef6246214b2c21de8c7e" => :high_sierra
    sha256 "8269781762ade44f9bcedcd2e0bcdcb567223b3d690f98dbf7b314f932d42039" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"
    ENV["GOPATH"] = buildpath

    src = buildpath/"src/github.com/jfrog/jfrog-cli-go"
    src.install buildpath.children
    src.cd do
      system "go", "run", "./python/addresources.go"
      system "go", "build", "-o", bin/"jfrog", "-ldflags", "-s -w -extldflags '-static'"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
  end
end
