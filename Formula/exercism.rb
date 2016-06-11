require "language/go"

class Exercism < Formula
  desc "command-line tool to interact with exercism.io"
  homepage "http://cli.exercism.io"
  url "https://github.com/exercism/cli/archive/v2.2.6.tar.gz"
  sha256 "92a33052c497d03ace85f4c62f64e59c6a08f8ecd0cc03401f490412781d1116"
  head "https://github.com/exercism.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0dbc20e71d07714ba4205407b870a13051817183828e957c0b96bc8c21604b86" => :el_capitan
    sha256 "147253109b9ef578b4684b83b7ae2c7258a4493b12d70ad83e5f09ea003f3330" => :yosemite
    sha256 "0ee231c464afff29ddf03a9709707e3087748275170e3a77579a5385f2d2dcf7" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
      :revision => "bca61c476e3c752594983e4c9bcd5f62fb09f157"
  end

  go_resource "github.com/kardianos/osext" do
    url "https://github.com/kardianos/osext.git",
      :revision => "6e7f843663477789fac7c02def0d0909e969b4e5"
  end

  go_resource "golang.org/x/net" do
    url "https://github.com/golang/net.git",
      :revision => "d9558e5c97f85372afee28cf2b6059d7d3818919"
  end

  go_resource "golang.org/x/text" do
    url "https://github.com/golang/text.git",
      :revision => "3eb7007b740b66a77f3c85f2660a0240b284115a"
  end

  def install
    ENV["GOBIN"] = bin
    ENV["GOPATH"] = buildpath
    ENV["GOHOME"] = buildpath

    path = buildpath/"src/github.com/exercism/cli"
    path.install Dir["*"]

    Language::Go.stage_deps resources, buildpath/"src"

    cd path do
      system "go", "build", "./exercism/main.go"
    end

    bin.install path/"main" => "exercism"
  end

  test do
    assert_equal "exercism version #{version}",
      shell_output("#{bin}/exercism --version").strip
  end
end
