class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser/archive/v0.101.0.tar.gz"
  sha256 "30ba38000168cbee12218af9501c5e886cc1a965d0b816d4301d3edc5096c297"

  bottle do
    cellar :any_skip_relocation
    sha256 "938e8df35b89d4db30c61fe21245d68598e8888baab1d467372ff62d32b5ddf6" => :mojave
    sha256 "24a4f3db81eb93a46d25727606884e4772697768c8e1afb3f3f320a6b372238b" => :high_sierra
    sha256 "a9fece6d96a667181c1d214caa6a4cafa9b22c9007272297e76d8cfad887a11a" => :sierra
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
