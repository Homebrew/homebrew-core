class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli"
  url "https://github.com/JFrog/jfrog-cli-go/archive/1.30.4.tar.gz"
  sha256 "5a97e3eb2b53e2ee71851730fefd6094f3954a955ec47dee7d9349d31eb7de6c"

  bottle do
    cellar :any_skip_relocation
    sha256 "a19879c71928a5e252043c64d7d7159e16bc3f46375131e886ff01dc587f767b" => :catalina
    sha256 "cd45747c94a09239b5d11bc818f66ffa3584ea492cbf69a03f5189c4cf86baf1" => :mojave
    sha256 "463fa611350a9da1a2b0ad274c56e0791cf8e5b4e03ace0b8c82577e804800c8" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    src = buildpath/"src/github.com/jfrog/jfrog-cli"
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
