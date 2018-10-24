class Exercism < Formula
  desc "Command-line tool to interact with exercism.io"
  homepage "https://cli.exercism.io/"
  url "https://github.com/exercism/cli/archive/v3.0.10.tar.gz"
  sha256 "0dbb34ba3bb3571fbc75fa9f5cb0b061317589a98a1af12fe7318a2c4cdbda5b"
  head "https://github.com/exercism/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf6838adbbab67b08c786be8c6e6249966e19b89066b5adbd74e685632339605" => :mojave
    sha256 "bfa79cee498d5868fefad8fe90b265be4aeda00fae8493b0051d43b0101c029c" => :high_sierra
    sha256 "d82b748471c79952180123c34076d969236de874f18982d3edd97ba3cd381c33" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/exercism/cli").install buildpath.children
    cd "src/github.com/exercism/cli" do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", bin/"exercism", "exercism/main.go"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/exercism version")
  end
end
