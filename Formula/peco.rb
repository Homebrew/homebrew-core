class Peco < Formula
  desc "Simplistic interactive filtering tool"
  homepage "https://github.com/peco/peco"
  url "https://github.com/peco/peco/archive/v0.4.9.tar.gz"
  sha256 "e4e60653dbdbd76618fe0385ba6b4074c41378273f8a2346e0b7eea1e827b221"
  head "https://github.com/peco/peco.git"

  bottle do
    sha256 "65d0821921690eb13ee848a1b2e01493d9e07f97e294f75a71db1c73257fc5b1" => :sierra
    sha256 "ca56ef64855d055f755e7274ceceb1616fee1fedebaf60d365f89a626b590c23" => :el_capitan
    sha256 "b4d0570bb56b95beef490b68e13de18ea31b246118d87e5165f13a8454396479" => :yosemite
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
