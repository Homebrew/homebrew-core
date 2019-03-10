require "language/go"

class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.nl/"
  url "https://github.com/mmarkdown/mmark/archive/v2.0.40.tar.gz"
  sha256 "6013da8bd80f68d627d8f7c147d9c0370d0543bd100dd6f7c7adc1dcc68be6b3"

  bottle do
    cellar :any_skip_relocation
    sha256 "ccc7588477d1e0f5f66b2bc89630762353ff1626c86f82e2f905980ed067f938" => :mojave
    sha256 "d90ba0c314c2d24c5d71554f50030c44e7008c735e70aeacc530da0de5304518" => :high_sierra
    sha256 "5cf03a5de3805f0563091752d7ca913ad9e4378b988469418b745314116f0bf6" => :sierra
  end

  depends_on "go" => :build

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git",
        :revision => "3012a1dbe2e4bd1391d42b32f0577cb7bbc7f005"
  end

  go_resource "github.com/gomarkdown/markdown" do
    url "https://github.com/gomarkdown/markdown.git",
        :revision => "ee6a7931a1e4b802c9ff93e4dabcabacf4cb91db"
  end

  go_resource "github.com/mmarkdown/markdown" do
    url "https://github.com/mmarkdown/markdown.git",
        :revision => "d1d0edeb5d8598895150da44907ccacaff7f08bc"
  end

  resource "test" do
    url "https://raw.githubusercontent.com/mmarkdown/mmark/v2.0.7/rfc/2100.md"
    sha256 "2d220e566f8b6d18cf584290296c45892fe1a010c38d96fb52a342e3d0deda30"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/mmarkdown/"
    ln_sf buildpath, buildpath/"src/github.com/mmarkdown/mmark"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", bin/"mmark"
    man1.install "mmark.1"
    doc.install "Syntax.md"
  end

  test do
    resource("test").stage do
      system "#{bin}/mmark", "-2", "-ast", "2100.md"
    end
  end
end
