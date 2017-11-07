class Immortal < Formula
  desc "OS agnostic (*nix) cross-platform supervisor"
  homepage "https://immortal.run/"
  url "https://github.com/immortal/immortal/archive/0.17.0.tar.gz"
  sha256 "d3aa471f5c391a2f068048b0d3a408d1e24993adfe841920367a7156c2c56400"

  head "https://github.com/immortal/immortal.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "33e6319abe4584cec0ded5cfa27f7c9c04f99013eed17e2fed45055f61bdf502" => :high_sierra
    sha256 "02f4489c2f01ee2b8255ff39e4ea31d1395e99fc1279b20079de883c62751933" => :sierra
    sha256 "a49c5e210b009a6dbbd662f16a89b650470a291f192058e1e88dc817397f1be5" => :el_capitan
    sha256 "b7b2835be2e0984d1e756312144e81029de34e1e83fbe7edf1eef8ae07ec392a" => :yosemite
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/immortal/immortal").install buildpath.children
    cd "src/github.com/immortal/immortal" do
      system "dep", "ensure"
      ldflags = "-s -w -X main.version=#{version}"
      system "go", "build", "-ldflags", ldflags, "-o", "#{bin}/immortal", "cmd/immortal/main.go"
      system "go", "build", "-ldflags", ldflags, "-o", "#{bin}/immortalctl", "cmd/immortalctl/main.go"
      system "go", "build", "-ldflags", ldflags, "-o", "#{bin}/immortaldir", "cmd/immortaldir/main.go"
      man8.install Dir["man/*.8"]
      prefix.install_metafiles
    end
  end

  test do
    system bin/"immortal", "-v"
    system bin/"immortalctl", "-v"
    system bin/"immortaldir", "-v"
  end
end
