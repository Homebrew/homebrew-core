class GoStatik < Formula
  desc "Embed files into a Go executable"
  homepage "https://github.com/rakyll/statik"
  url "https://github.com/rakyll/statik/archive/v0.1.1.tar.gz"
  sha256 "c68ef3120a22bcf5bd5e8391db3507baeefc7047aa6539053229885287d0beb3"

  bottle do
    cellar :any_skip_relocation
    sha256 "4cb6f07c12fc07134618e3e8a675dc33f3098bcb756a1435351c4aa7fce95039" => :high_sierra
    sha256 "5ccab9ad9db0e4cbb3ee5f59d1cbeb919b16dd3fcee9b851050555e045a8f9a6" => :sierra
    sha256 "8918cffc571af3338da4269b7016421f512b037409adb57ad07e1fd2a4113cbf" => :el_capitan
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
