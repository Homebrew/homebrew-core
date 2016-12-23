class Peco < Formula
  desc "Simplistic interactive filtering tool"
  homepage "https://github.com/peco/peco"
  url "https://github.com/peco/peco/archive/v0.4.7.tar.gz"
  sha256 "13b14c547a4fa54c33e14a3a5c18d971961963008e22410fe377614100a34c00"
  head "https://github.com/peco/peco.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1d0329f9e239dca2083efb752384c4a827ac7861add4dc3c07d116d689947898" => :sierra
    sha256 "27146cadf7d4e4bc2f1cdf5753d5954d6c2b53a6bf179a58041f767db73746dc" => :el_capitan
    sha256 "50c6670b272e8438af1800bbe328aac1185288d1d33126f3cb83870e88837e61" => :yosemite
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
