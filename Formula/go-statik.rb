class GoStatik < Formula
  desc "Embed files into a Go executable"
  homepage "https://github.com/rakyll/statik"
  url "https://github.com/rakyll/statik/archive/v0.1.7.tar.gz"
  sha256 "cd05f409e63674f29cff0e496bd33eee70229985243cce486107085fab747082"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "96680660a5fbb155a621fe3ce3826c6cbd483ddd34619b8430f56f7ef5f36151" => :big_sur
    sha256 "7f327c7e3066449e5f85d3a209c587838ebe5fba11092f21ce8e7977008bd703" => :arm64_big_sur
    sha256 "923729f442bef89c09fc9818c4f2ff1689a099b7519285372d7f5448e5b88fcc" => :catalina
    sha256 "3834b8aa037b4e5b84caaa68aa6170f482869e73098af131f0a93b0e4dba3454" => :mojave
    sha256 "79b923320dfeb847b229ee880cd8aa1c11a77026d6070bb33ebaee1d76b67198" => :high_sierra
  end

  depends_on "go" => :build

  conflicts_with "statik", because: "both install `statik` binaries"

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"
    mv bin/"go-statik", bin/"statik"
  end

  test do
    font_name = (MacOS.version >= :catalina) ? "Arial Unicode.ttf" : "Arial.ttf"
    system bin/"statik", "-src", "/Library/Fonts/#{font_name}"
    assert_predicate testpath/"statik/statik.go", :exist?
    refute_predicate (testpath/"statik/statik.go").size, :zero?
  end
end
