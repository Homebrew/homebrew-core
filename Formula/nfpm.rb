class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.1.1.tar.gz"
  sha256 "a9f95c91c01a0bebe191ce50d8a871f5c004bdafcab0c0812eb375882610fdfa"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "27b3aaabd667f080d8c60758a9471ef0a91db05080cceb3b1a955defc8474d2e" => :big_sur
    sha256 "54d1325e169a6192a064d0ee179aeba6e673fdcbb3099f12024858accd91530a" => :arm64_big_sur
    sha256 "2975a2bed13d80766fda339439f93181708478d32bc11f582ab27317e7992aa1" => :catalina
    sha256 "f623c44ce65c0da16debe059e5974eb66bc0ebca9d894077bd423944c7d5e0db" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-X main.version=v#{version}", *std_go_args, "./cmd/nfpm"
  end

  test do
    assert_match version.to_s,
      shell_output("#{bin}/nfpm --version 2>&1")

    system bin/"nfpm", "init"
    assert_match "nfpm example config file", File.read(testpath/"nfpm.yaml")

    # remove the generated default one
    # and use stubbed one for another test
    File.delete(testpath/"nfpm.yaml")
    (testpath/"nfpm.yaml").write <<~EOS
      name: "foo"
      arch: "amd64"
      platform: "linux"
      version: "v1.0.0"
      section: "default"
      priority: "extra"
    EOS

    system bin/"nfpm", "pkg", "--packager", "deb", "--target", "."
    assert_predicate testpath/"foo_1.0.0_amd64.deb", :exist?
  end
end
