class Peco < Formula
  desc "Simplistic interactive filtering tool"
  homepage "https://github.com/peco/peco"
  url "https://github.com/peco/peco/archive/v0.5.1.tar.gz"
  sha256 "1acbf8f7f077208a8d4406a37be88783432455d6ff905e0a19168c7c2a34f1c8"
  head "https://github.com/peco/peco.git"

  bottle do
    cellar :any_skip_relocation
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
