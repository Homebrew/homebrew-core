class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.135.0",
      :revision => "b8d32449f4373228ccbb408f1a3ebb84cc3fae61"

  bottle do
    cellar :any_skip_relocation
    sha256 "59e4853d43280ba51e0d7064167d9b7c2f394fd8ddeb65c5a19e84928ff778af" => :catalina
    sha256 "98e0e462f78747d91e5fdcbf8b106bc02d10f6411d7ff16f0c5a250037351b68" => :mojave
    sha256 "43db0650b22e8c0cac804405b9aabe04b70d403537ee65a80d4de2993f4cd685" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X main.version=#{version} -X main.commit=#{stable.specs[:revision]} -X main.builtBy=homebrew",
             *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
