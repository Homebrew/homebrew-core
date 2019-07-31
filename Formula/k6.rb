class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/loadimpact/k6.git",
    :tag      => "v0.25.0",
    :revision => "c53607db0ef32be9535d1b516c90275fb37a54cf"

  bottle do
    cellar :any_skip_relocation
    sha256 "7bf3b04410bacde97e906860addced0403d96a4c0fcab8efcec811c4a0bf9da3" => :mojave
    sha256 "0a59d836290c7b499dfa5718dcbf05559f6fdc9b287a737bbfecf0bdb6dc3c6e" => :high_sierra
    sha256 "3c32a857ca8b388bc4715bf73a3f661a500d25795c6b213012beb8c6bab657f4" => :sierra
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
