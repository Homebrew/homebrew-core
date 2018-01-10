class Immortal < Formula
  desc "OS agnostic (*nix) cross-platform supervisor"
  homepage "https://immortal.run/"
  url "https://github.com/immortal/immortal/archive/0.18.0.tar.gz"
  sha256 "8a2328daa5fce82e333fa01e1d87ea7720a405756788cc7edee96b7bb22b26e8"
  head "https://github.com/immortal/immortal.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "af1a49059071713a330692106f9309911c398d375c425481702b812406e01547" => :high_sierra
    sha256 "2744498ed27a3e7401cf8905a01498e10cb898d8e6786763907f59f64c1cac75" => :sierra
    sha256 "33cf0dae84b792e44e256a9fec29e08e0d0ae3ad2598470f0b2328be200b3adc" => :el_capitan
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
