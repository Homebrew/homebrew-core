class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://github.com/mmarkdown/mmark/archive/v2.0.51.tar.gz"
  sha256 "0d0c41b3b1fa6d9847bbf72b711522b6bd493bc85f2946985b271c9ab6c13be5"

  bottle do
    cellar :any_skip_relocation
    sha256 "b89f435ecd4fdaf59028006aa65175b9095c4ed0676198554d50c9901022fa8d" => :mojave
    sha256 "de8e68d769fd69b3a6069bbb2d7c0be4a9cca29711e38215263ad4b7debc741a" => :high_sierra
    sha256 "d5ccc252704256bd044758dbb4435b91fdfe61cb060dcac23a3318997edcc026" => :sierra
  end

  depends_on "go" => :build

  resource "test" do
    url "https://raw.githubusercontent.com/mmarkdown/mmark/v2.0.7/rfc/2100.md"
    sha256 "2d220e566f8b6d18cf584290296c45892fe1a010c38d96fb52a342e3d0deda30"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

    (buildpath/"src/github.com/mmarkdown/mmark").install buildpath.children
    cd "src/github.com/mmarkdown/mmark" do
      system "go", "build", "-o", bin/"mmark"
      man1.install "mmark.1"
      prefix.install_metafiles
    end
  end

  test do
    resource("test").stage do
      system "#{bin}/mmark", "-2", "-ast", "2100.md"
    end
  end
end
