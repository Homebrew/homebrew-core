class Ctop < Formula
  desc "Top-like interface for container metrics"
  homepage "https://bcicen.github.io/ctop/"
  url "https://github.com/bcicen/ctop/archive/v0.5.1.tar.gz"
  sha256 "45cdcd0bb145b1b1312c464690669635abfd09c0b591b41c3771492d0db6d43f"

  bottle do
    cellar :any_skip_relocation
    sha256 "4925e2c0d9bfda6d11bb1a65be18f533e8255b8715608840cbd1ff2b5db8787a" => :sierra
    sha256 "c3b3cc72c661c7b6ead5d1bb993aecb45e22df845b8252964cfce3779c6c1c7c" => :el_capitan
    sha256 "0b294c3e766755428f1b96f60894ba75ba8d62c158135195f3acf0e39764378a" => :yosemite
  end

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    dir = buildpath/"src/github.com/bcicen/ctop"
    dir.install Dir["*"]
    cd dir do
      system "glide", "install"
      system "make", "build"
      bin.install "ctop"
    end
  end

  test do
    system "#{bin}/ctop", "-v"
  end
end
