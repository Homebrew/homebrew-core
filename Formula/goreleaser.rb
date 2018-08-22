class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser/archive/v0.83.3.tar.gz"
  sha256 "37614330b19709de4fab649a8e15b78208dca3a119314256fa064cbc4ad8acac"

  bottle do
    cellar :any_skip_relocation
    sha256 "7e90cb100fecffbc3844085534047ca4b1fbd2dce023b3bfc975480b5c25957e" => :mojave
    sha256 "9c20b99ccf58b35e28e855ce05ccf2a48cca10c9a879809d1534bcf25d0346bc" => :high_sierra
    sha256 "b8c3299239d31d221b255002830eeda9be834ef29b8e76eccc9262c55baeb6e3" => :sierra
    sha256 "d00255045647e84a162c325034c2b5425fa2c747c6e9fe6182980f1cd599fea2" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/goreleaser/goreleaser").install buildpath.children
    cd "src/github.com/goreleaser/goreleaser" do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-ldflags", "-X main.version=#{version}", "-o",
             bin/"goreleaser"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
