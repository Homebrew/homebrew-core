class Immortal < Formula
  desc "OS agnostic (*nix) cross-platform supervisor"
  homepage "https://immortal.run/"
  url "https://github.com/immortal/immortal/archive/0.18.0.tar.gz"
  sha256 "8a2328daa5fce82e333fa01e1d87ea7720a405756788cc7edee96b7bb22b26e8"
  head "https://github.com/immortal/immortal.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "deebb8a1f75da45655d196fbb8d3cc557604e8c65b7ae0fcaa1ba1995861a53a" => :high_sierra
    sha256 "a174ec2100bd0f6cd9b685e7baec1e0de0f93e949300631b69bbe05e1d26e11e" => :sierra
    sha256 "71a52e92493c351223aee8cbc69dc21cc0d7cac516296685403c8c4da939111f" => :el_capitan
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
