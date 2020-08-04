class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/loadimpact/k6.git",
    tag:      "v0.27.1",
    revision: "4ee1ca9624bdd9fa68a0d534be11ac22328f1821"
  license "AGPL-3.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "afa071cb66ffb37e6718ee52be4b58b707b935765f6527415da7dc15c2297658" => :catalina
    sha256 "78bad35beeaa7d16a8f55aa2f9980b74c07fdec191c7ca52085ff0a2f8aa476c" => :mojave
    sha256 "8f66f1625d3e95c011ead1d2fdfc3aed6102d9f9a475f9ec093cb50fa40503c4" => :high_sierra
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
    (testpath/"whatever.js").write <<~EOS
      export default function() {
        console.log("whatever");
      }
    EOS

    assert_match "whatever", shell_output("#{bin}/k6 run whatever.js 2>&1")
    assert_match version.to_s, shell_output("#{bin}/k6 version")
  end
end
