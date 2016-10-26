class Peco < Formula
  desc "Simplistic interactive filtering tool"
  homepage "https://github.com/peco/peco"
  url "https://github.com/peco/peco/archive/v0.4.4.tar.gz"
  sha256 "6cff76311443172eb1aae6b4bb529059d96e20438850ed046c1bc03eb4f1b4b7"
  head "https://github.com/peco/peco.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6b9efa0d3526188530b8c38f0d20c486803244ba89ffaf517e2bdb88a985ae03" => :sierra
    sha256 "673edd15fd816209a33dd39d88f338e7b2b16934d8521a38ede69dce6c97a3d7" => :el_capitan
    sha256 "acefd4857ebd663a0f44a712866a5bbe558cde50c13aca9ae13bc9945ede41bc" => :yosemite
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
