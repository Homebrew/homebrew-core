class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.138.0",
      :revision => "fdfae298c6e4adfc941aaca0b96747c3a02c919b"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e453855ddf3b987db54566d87dbd3ea6b2972c28a838179bff6002b06722ae7" => :catalina
    sha256 "de95155dbc61c4a28c9004eb7354be935a1bc8e19c9097f4aeb93c9f4144d207" => :mojave
    sha256 "8f198df37a0ff0cd007f19482b9868c5876464b37e98025c1a44ca2c486e7f77" => :high_sierra
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
