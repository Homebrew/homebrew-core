class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser/archive/v0.92.1.tar.gz"
  sha256 "4d854d582dff254ac2477153801f2d5b436e3a147e6d9068ea7c0f68ad416223"

  bottle do
    cellar :any_skip_relocation
    sha256 "1b1b173f930a58397accb15844b67f08ccb2cb5adbf2417de6ae6d8c90fb3f4e" => :mojave
    sha256 "113969de2c4a5e379f0efa9b359245b58cf323498a5d8f815ed5c42dea92eff6" => :high_sierra
    sha256 "6fff151cd205c32918ede68fb8f4e659d3509f4f6b3ca13d11f9335db4da0807" => :sierra
    sha256 "4e3ae6c84016b38b784de65ebcb3a7691b2b7064c831f781529ddb69a0220b8d" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    (buildpath/"src/github.com/goreleaser/goreleaser").install buildpath.children
    cd "src/github.com/goreleaser/goreleaser" do
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
