class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.140.1",
      :revision => "47e88b9bcf6d9567ee95db4d3d1b2516734386e6"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "742d428bc3a6d0ebdfb3108bd5941f5acb8eba3d3fdbbbb74005ba93904b9829" => :catalina
    sha256 "8203e518b119e4e4d0a39c0b2bd32ce750a3bddba425c343e69d40ef3c4677dd" => :mojave
    sha256 "fc4ac964b17c760e653e725a0e5f46199e67aef532d044ff1341726676110166" => :high_sierra
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
