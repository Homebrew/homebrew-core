class Exercism < Formula
  desc "Command-line tool to interact with exercism.io"
  homepage "http://cli.exercism.io"
  url "https://github.com/exercism/cli/archive/v3.0.4.tar.gz"
  sha256 "7c406cb5f1d70af5373e0ecf856e810a4bff2494780ce7a285b6a4719a875dd7"
  head "https://github.com/exercism/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed72159be6a84c2b9ea9dbb51bb1e1ff0dca0dcd05bd2978bafd8da36e45e033" => :high_sierra
    sha256 "64872c3d8eb8a37d9cfac2baa3054a29fbaf9def137647b9a3831f591a39333d" => :sierra
    sha256 "432c646530d6ce6d6e12129fa5a4abba98af225a58c5a07c9e1626e0420e4fbf" => :el_capitan
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
