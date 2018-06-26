class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser/archive/v0.79.0.tar.gz"
  sha256 "d8f2b3b61392a0c863b7bc9332f64685048a5912c89a10cab133bb19687e74e7"

  bottle do
    cellar :any_skip_relocation
    sha256 "1e39acfbc1b79eb6c3dd80707cd56c3099ee35422718bb42da7960ec27f6a941" => :high_sierra
    sha256 "a7259ea61ed9712fa28e4e37ff7b613856457d32a63883e19a0d133faf5c9736" => :sierra
    sha256 "08145321507ccd11dc061b1d931850b6b10089d4aa3de7b253e84cb1a30f60b7" => :el_capitan
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
