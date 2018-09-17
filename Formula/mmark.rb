require "language/go"

class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.nl/"
  url "https://github.com/mmarkdown/mmark/archive/v2.0.7.tar.gz"
  sha256 "8ab83495b21d0b05fd763f3a79aeaf983c6905eccfbcca48f63c169ef3705639"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f44a848ea631eb30d12a0268056f6a43aa4b19c12a03498dc3819e8abd6e4cd" => :mojave
    sha256 "6f8482d9d2c05aab64664281af2dd617637eadf61762b40e6b8bd284495b193d" => :high_sierra
    sha256 "195b590522d39c6ca3e298615e5b21112c0cbe7b33db367565d67268ae3a4fe4" => :sierra
    sha256 "062eca50beb44f55e4940edb11ae3c1e9a0c4360b5d770f4c7ee0f37631543b9" => :el_capitan
  end

  depends_on "go" => :build

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git",
        :revision => "3012a1dbe2e4bd1391d42b32f0577cb7bbc7f005"
  end

  go_resource "github.com/gomarkdown/markdown" do
    url "https://github.com/gomarkdown/markdown.git",
        :revision => "6fda95a9e93f739db582f4a3514309830fd47354"
  end

  go_resource "github.com/mmarkdown/markdown" do
    url "https://github.com/mmarkdown/markdown.git",
        :revision => "6fda95a9e93f739db582f4a3514309830fd47354"
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
