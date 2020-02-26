class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/loadimpact/k6.git",
    :tag      => "v0.26.1",
    :revision => "4c49f9a3b075e958435800f2a8a0c83b0174cfd7"

  bottle do
    cellar :any_skip_relocation
    sha256 "31c1eb978c2bac444f0712698e535ffb67020f688e21031e537cf65aea93b5a1" => :catalina
    sha256 "14f528008bebe17d734395080e8bfaeb7b638d114e0e560c38d682871e762918" => :mojave
    sha256 "39ff1b7c0b4149e243ab261bcfe74f36e862230e35b57560c691896801ff51d1" => :high_sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/loadimpact/k6"
    dir.install buildpath.children

    cd dir do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", bin/"k6"
      prefix.install_metafiles
    end
  end

  test do
    output = "Test finished"
    assert_match output, shell_output("#{bin}/k6 run github.com/loadimpact/k6/samples/http_get.js 2>&1")
    assert_match version.to_s, shell_output("#{bin}/k6 version")
  end
end
