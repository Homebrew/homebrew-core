class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/loadimpact/k6.git",
    :tag      => "v0.26.2",
    :revision => "459da79ef51b37e5eaba4575c9065d9e592e5c49"

  bottle do
    cellar :any_skip_relocation
    sha256 "70f6f2d4386f07c89b1139a5d3feedeea8eba9a443ff6c9ac88b6d88d7120416" => :catalina
    sha256 "6f70e79b736f65282837f018405e5a414d87cb8bcb49e7d1b852ad5d3771fece" => :mojave
    sha256 "a809b4232be33515a8d5038745daac93caa94141ab8787772fd034df392378fe" => :high_sierra
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
