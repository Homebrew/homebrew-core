class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.133.0",
      :revision => "83e401cfa52ba0f5ad75a6116108cdbe587bbb01"

  bottle do
    cellar :any_skip_relocation
    sha256 "4cb80f8166c350e5d19823f719443251dce3698e09ca9a916423e7dc46fb977b" => :catalina
    sha256 "9ea1ba1403c71d7923c6175d33db91376128e94bb16f90c645da25b412cb3e34" => :mojave
    sha256 "e83acf87c78579a58dd95d33ff8014ccaa86f0b97937c84e0fece86646ceb9d5" => :high_sierra
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
