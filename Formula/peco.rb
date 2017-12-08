class Peco < Formula
  desc "Simplistic interactive filtering tool"
  homepage "https://github.com/peco/peco"
  url "https://github.com/peco/peco/archive/v0.5.2.tar.gz"
  sha256 "347593999c27d9e67bbd1add38de065d2b586cf9d9758c3a0873c69287ca6986"
  head "https://github.com/peco/peco.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ae89ca515edd1ea135391c49b5bd59a58b61429b5853c8637270508704e7e49a" => :high_sierra
    sha256 "e887238702e3e59f087e4b61d35fc600c62e2f24be735199e500b97b87e10ac2" => :sierra
    sha256 "6469680e257c01946da55709a43432cd8036bfbd42f0ec19ce6dc61c8a29a76d" => :el_capitan
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
