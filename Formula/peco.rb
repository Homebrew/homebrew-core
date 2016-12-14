class Peco < Formula
  desc "Simplistic interactive filtering tool"
  homepage "https://github.com/peco/peco"
  url "https://github.com/peco/peco/archive/v0.4.6.tar.gz"
  sha256 "a90a1d7b4f89125b9fd79ea7f27672825e1a3f260555e05152e4ba4db32ec9b8"
  head "https://github.com/peco/peco.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a1aeba94f4a4dd45f0124561fb495fb3b03f56b010a82fadd5e915c3e5221c3c" => :sierra
    sha256 "b3724a21d989b5ad8825b8031dd3d21d956187a2a9f4f347722cccba54e6a9c7" => :el_capitan
    sha256 "3015e4ff65c7fd8be687801735fe44e32c78c26986c67dfe5a3565e9936b555d" => :yosemite
  end

  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    (buildpath/"src/github.com/peco/peco").install buildpath.children
    cd "src/github.com/peco/peco" do
      system "glide", "install"
      system "go", "build", "-o", bin/"peco", "cmd/peco/peco.go"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/peco", "--version"
  end
end
