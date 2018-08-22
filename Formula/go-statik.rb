class GoStatik < Formula
  desc "Embed files into a Go executable"
  homepage "https://github.com/rakyll/statik"
  url "https://github.com/rakyll/statik/archive/v0.1.4.tar.gz"
  sha256 "3f547d8d2033b1b16a3549f48b69e8671a64fd6b18aea2322007f54c837d1dde"

  bottle do
    cellar :any_skip_relocation
    sha256 "df1233d8622a603cfc1376df589dde68eacfed61d936adb5ef5b76fc3f7498c2" => :high_sierra
    sha256 "a8d36c584b4ec26387492ad32470847890bc853734f072253050429d64430457" => :sierra
    sha256 "925e6aefe2b2a928cd79cdde8d7d840b52b4d9766daad7e331025eb2823f80af" => :el_capitan
  end

  depends_on "go" => :build

  conflicts_with "statik", :because => "both install `statik` binaries"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/rakyll/statik").install buildpath.children

    cd "src/github.com/rakyll/statik" do
      system "go", "build", "-o", bin/"statik"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"statik", "-src", "/Library/Fonts/STIXGeneral.otf"
    assert_predicate testpath/"statik/statik.go", :exist?
    refute_predicate (testpath/"statik/statik.go").size, :zero?
  end
end
