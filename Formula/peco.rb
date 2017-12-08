class Peco < Formula
  desc "Simplistic interactive filtering tool"
  homepage "https://github.com/peco/peco"
  url "https://github.com/peco/peco/archive/v0.5.2.tar.gz"
  sha256 "347593999c27d9e67bbd1add38de065d2b586cf9d9758c3a0873c69287ca6986"
  head "https://github.com/peco/peco.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e5adad1de9144d6ef9b5c53dd713272e47dbf1ba13fecdc92059f54cd342e7fa" => :high_sierra
    sha256 "78e54d92559b862a2620392cd0274e59693718a69c1a133d2b0d932889bad2c6" => :sierra
    sha256 "d91fdde06f21ab5d27ff2fba0118facfbda8f77d9d3cdfb8368bb1a4678e2470" => :el_capitan
    sha256 "0740fec8c778247f3bbeac76376fff7097cc8ed756d0c029f106c21fa105705e" => :yosemite
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
