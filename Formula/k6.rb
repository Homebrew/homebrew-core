class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/loadimpact/k6.git",
    :tag      => "v0.25.0",
    :revision => "c53607db0ef32be9535d1b516c90275fb37a54cf"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec47aa43e5d83dd4ac5bb114ebe79bef61ae58e731dfd47406628a2ce25705e4" => :mojave
    sha256 "d52262f96a05ef960fb44f4d46713cecb99d3d32443a0ac5a216d990ad39064c" => :high_sierra
    sha256 "05f67008016aa9296a77ed1cead0e6dffd56ff0d1259fcda3bd958346c16be6b" => :sierra
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
