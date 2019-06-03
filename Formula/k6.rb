class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/loadimpact/k6.git",
    :tag      => "v0.24.0",
    :revision => "f597e5f66d22f697a386752ea0f4b0361765ab34"

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
