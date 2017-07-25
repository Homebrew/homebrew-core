class Monax < Formula
  desc "Blockchain application platform CLI"
  homepage "https://erisindustries.com"
  url "https://github.com/monax/monax/archive/v0.18.0.tar.gz"
  sha256 "fa90621e8d518c10ea6c239fdd917196f5be5a523d257a4c1855e0bd3ca1e7bd"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "305385f9e631893c31496dfef6fe1aa0c87865cc7e66b94a749f853853ea1249" => :sierra
    sha256 "64a6b82656b477b0edcdbd9f1a1c3dd937419b890ee96f623a36de6cf46e9bac" => :el_capitan
    sha256 "7010eb9e3521f32597c4c965c8858969250ceca0426e2b3acd724a0b8d1119e1" => :yosemite
  end

  depends_on "go" => :build
  depends_on "docker"
  depends_on "docker-machine"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin
    (buildpath/"src/github.com/monax").mkpath
    ln_sf buildpath, buildpath/"src/github.com/monax/monax"
    system "go", "install", "github.com/monax/monax/cmd/monax"
  end

  test do
    system "#{bin}/monax", "version"
  end
end
