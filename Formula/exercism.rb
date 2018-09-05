class Exercism < Formula
  desc "Command-line tool to interact with exercism.io"
  homepage "https://cli.exercism.io/"
  url "https://github.com/exercism/cli/archive/v3.0.9.tar.gz"
  sha256 "eef2093d6c80e1f8d871e26512d3be20ee2bbf2ea9e53e41d652102af3d7a97d"
  head "https://github.com/exercism/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9c972fee59447e2f02905b31a75d4de3e221fc5ecf0e229dbb9a91c0d74e8064" => :mojave
    sha256 "a2abf4b74c4dc0e149b8b914351788ac15328729ea3d996be8dd37b8238bedf4" => :high_sierra
    sha256 "967b4bb505530bfceeb1a69c98da1d7e49785ad45e6c50edc4fb74cc8c51f13e" => :sierra
    sha256 "7996e32a509023a58131868a29f0cc15e8c3160031aaa9ce0b13eae3824325e5" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/exercism/cli").install buildpath.children
    cd "src/github.com/exercism/cli" do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", bin/"exercism", "exercism/main.go"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/exercism version")
  end
end
