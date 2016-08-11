class Exercism < Formula
  desc "command-line tool to interact with exercism.io"
  homepage "http://cli.exercism.io"
  url "https://github.com/exercism/cli/archive/v2.3.0.tar.gz"
  sha256 "ca1432af80f9257c4c06107d0d1732845d49ac450f56ea04bcf58ead46d0af74"
  head "https://github.com/exercism/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0dbc20e71d07714ba4205407b870a13051817183828e957c0b96bc8c21604b86" => :el_capitan
    sha256 "147253109b9ef578b4684b83b7ae2c7258a4493b12d70ad83e5f09ea003f3330" => :yosemite
    sha256 "0ee231c464afff29ddf03a9709707e3087748275170e3a77579a5385f2d2dcf7" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/exercism/cli").install buildpath.children
    cd "src/github.com/exercism/cli" do
      system "go", "build", "-o", bin/"exercism", "exercism/main.go"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/exercism --version")
  end
end
