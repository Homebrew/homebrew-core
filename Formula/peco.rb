class Peco < Formula
  desc "Simplistic interactive filtering tool"
  homepage "https://github.com/peco/peco"
  url "https://github.com/peco/peco/archive/v0.4.8.tar.gz"
  sha256 "c7006b0baeb6d356875c258ba31527c7c222be5dd4e0ada93cc13eafa2788100"
  head "https://github.com/peco/peco.git"

  bottle do
    sha256 "ac84b8afe557e6baf24607ac05511cab1910674a0478045c8384e4e352700518" => :sierra
    sha256 "b885e6a78219ebb36f4dc7aec881df72dbe25e869edfd034ee6612bde5705cb8" => :el_capitan
    sha256 "dd177592ff05760915788de0b4f6e49fed19c9b045dd356914054acb44d24778" => :yosemite
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
