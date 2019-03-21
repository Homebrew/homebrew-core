class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser/archive/v0.104.0.tar.gz"
  sha256 "a86eb40fc9d2df187812fd765980c0b5d4a9aecd5bd0dfc827b37d85f5e5a73f"

  bottle do
    cellar :any_skip_relocation
    sha256 "62ad5cdab9093410183d4e3a93f038e87ae2919a3b05f5760e7cb5ab158b0ad9" => :mojave
    sha256 "021630fc4875fbf41a4e8184c96a69ae6a6b3425af6fcba2e062da4498508824" => :high_sierra
    sha256 "1324ced56cf8b35f662b6c69b7d74459abba736fefa715651eec0bad53cd0d35" => :sierra
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
