class Exercism < Formula
  desc "Command-line tool to interact with exercism.io"
  homepage "http://cli.exercism.io"
  url "https://github.com/exercism/cli/archive/v3.0.3.tar.gz"
  sha256 "0fb6ada283b20003542066cd62ba8258cc8a8f7cbaeb3e676d43d35776926d6a"
  head "https://github.com/exercism/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d0f8c38f7dcf7b94ae0e9533446aa2d0ad106e8a9aa4c3d9b03a4d19c6d6edca" => :high_sierra
    sha256 "c7d1280150c377e5b2d3268dd0e63bc5c05633bd0777c9665819a8f920d4b06b" => :sierra
    sha256 "4fc9d31b82b6dac2e028290b231c6b87f0c5602c398119d648eba0205e77aa86" => :el_capitan
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
