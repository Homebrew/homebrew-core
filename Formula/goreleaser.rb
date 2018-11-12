class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser/archive/v0.93.1.tar.gz"
  sha256 "cdb339ced74dc25513e6533e5ec385f41d7b542c57a86ce9d2cc7e1b5c51e8f9"

  bottle do
    cellar :any_skip_relocation
    sha256 "0b4aa520381ae8d9fd428ab1c57040515c17dd8a13535f8f9d7b76bb948b1564" => :mojave
    sha256 "b79ca013bd74d660a2f8325282dfc58f18884fe2d9f3b538d2786918c42cf368" => :high_sierra
    sha256 "0fc46598f1166fcd8492552fc1435051bb473e3760ce8c1efa830caa286c549d" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    (buildpath/"src/github.com/goreleaser/goreleaser").install buildpath.children
    cd "src/github.com/goreleaser/goreleaser" do
      system "go", "build", "-ldflags", "-X main.version=#{version}",
                   "-o", bin/"goreleaser"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
