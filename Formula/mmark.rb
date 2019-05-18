class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.nl/"
  url "https://github.com/mmarkdown/mmark/archive/v2.0.46.tar.gz"
  sha256 "fa64a7321ff8cc531a0caa36af2a72057c5bebd634b623407b9d6415e7184003"

  bottle do
    cellar :any_skip_relocation
    sha256 "ccc7588477d1e0f5f66b2bc89630762353ff1626c86f82e2f905980ed067f938" => :mojave
    sha256 "d90ba0c314c2d24c5d71554f50030c44e7008c735e70aeacc530da0de5304518" => :high_sierra
    sha256 "5cf03a5de3805f0563091752d7ca913ad9e4378b988469418b745314116f0bf6" => :sierra
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
