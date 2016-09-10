class Peco < Formula
  desc "Simplistic interactive filtering tool"
  homepage "https://github.com/peco/peco"
  url "https://github.com/peco/peco/archive/v0.4.2.tar.gz"
  sha256 "66dd72033653e41f26a2e9524ccc04650ebccb9af42daa00b106fc9e1436ddef"
  head "https://github.com/peco/peco.git"

  bottle do
    rebuild 1
    sha256 "a80123b65c81e70755903fb0a109b06ce5e0d2ad619b4bab969c911365cf92c6" => :el_capitan
    sha256 "938603872016a305e2fe9ccb650768af638938a5536e0db598d7c54580158dd5" => :yosemite
    sha256 "ec28524af8e8d33b4fcb16ca060600ce58d529f4b64b526affe350d886e2f1d3" => :mavericks
  end

  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = buildpath/"glide_home"
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
