require "language/go"

class Certigo < Formula
  desc "Utility to examine and validate certificates in a variety of formats."
  homepage "https://github.com/square/certigo"
  url "https://github.com/square/certigo/archive/v1.1.0.tar.gz"
  sha256 "1ca8ee1130d57fb70b1c21cc9311d8b036b86d456eb88888d603e88fbb1d056a"

  depends_on "go" => :build

  certigo_deps = %w[
    github.com/fatih/color 87d4004f2ab62d0d255e0a38f1680aa534549fe3
    gopkg.in/alecthomas/kingpin.v2 8cccfa8eb2e3183254457fb1749b2667fbc364c7
    github.com/alecthomas/units 2efee857e7cfd4f3d0138cc3cbb1b4966962b93a
    github.com/alecthomas/template a0175ee3bccc567396460bf5acd36800cb10c49c
    github.com/mattn/go-colorable 9056b7a9f2d1f2d96498d6d146acd1f9d5ed3d59
    github.com/mattn/go-isatty 56b76bdf51f7708750eac80fa38b952bb9f32639
  ]

  certigo_deps.each_slice(2) do |x, y|
    go_resource x do
      url "https://#{x}.git", :revision => y
    end
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
        :revision => "3760e016850398b85094c4c99e955b8c3dea5711"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = buildpath
    mkdir_p buildpath/"src/github.com/square/"
    ln_s buildpath, buildpath/"src/github.com/square/certigo"
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", "certigo"

    bin.install "certigo"
  end

  test do
    system "#{bin}/certigo", "help"
  end
end
