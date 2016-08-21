class Peco < Formula
  desc "Simplistic interactive filtering tool"
  homepage "https://github.com/peco/peco"
  url "https://github.com/peco/peco/archive/v0.4.1.tar.gz"
  sha256 "7ed3b7b695e1e7da62f1ee5c8b8f0a716860f0e1101cede28eed0760edf94da0"
  head "https://github.com/peco/peco.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c8c03e514e10c5d2c6824838a9d8777624f2295ac9d8fc7cca92a5298dcb0b22" => :el_capitan
    sha256 "5b8320b037471270db0c9c1a866c15d00225a2b1b147b74e4bdbb3e696e136db" => :yosemite
    sha256 "ca37bbcdaee4c45e850872b7835128e8ca1e675684e8e5e17d48b790cddca1d0" => :mavericks
  end

  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
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
