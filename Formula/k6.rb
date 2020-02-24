class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/loadimpact/k6.git",
    :tag      => "v0.26.1",
    :revision => "4c49f9a3b075e958435800f2a8a0c83b0174cfd7"

  bottle do
    cellar :any_skip_relocation
    sha256 "a37347418aa34da56fcf50e4f11eb5735db1f85327ead7755857c2e5c85b6975" => :catalina
    sha256 "1c5d771e9aba6851616da73b5f95afe7aff9956ffdccb0d772a7eeadd882c1c9" => :mojave
    sha256 "ef2090e52bbb7a655746392ef06a255b3f848916715ea79d772d08c4f1871308" => :high_sierra
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
