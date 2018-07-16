class Exercism < Formula
  desc "Command-line tool to interact with exercism.io"
  homepage "http://cli.exercism.io"
  url "https://github.com/exercism/cli/archive/v3.0.4.tar.gz"
  sha256 "7c406cb5f1d70af5373e0ecf856e810a4bff2494780ce7a285b6a4719a875dd7"
  head "https://github.com/exercism/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "de257927aea12e4690e66f575d0da5d9301cb0026f67d8f14a4bb0a1a4c337c2" => :high_sierra
    sha256 "2d29e590e7829b8954702a5d629d0ef6a1f9cb87c74a535143b9f6ac9f2b8574" => :sierra
    sha256 "544aad79aa6c760c3150bc0c935e75fac0c3ecea8e879104db65dbf522aca427" => :el_capitan
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
