class Massren < Formula
  desc "Easily rename multiple files using your text editor"
  homepage "https://github.com/laurent22/massren"
  url "https://github.com/laurent22/massren/archive/v1.5.6.tar.gz"
  sha256 "49758b477a205f3fbf5bbe72c2575fff8b5536f8c6b45f8f6bd2fdde023ce874"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55e1859aa5bca0987dd3fb314243b5d589bd17dbdcb21aea6aa635ee734203c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4f3dfe97777a1e9526c15d1f68c635dd742e6aa3474905eed26de63688eb86d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2911c014673d7dd0eb6333dcca8ed9a56d6ef14467c2f5cbb0b16a433e35991a"
    sha256 cellar: :any_skip_relocation, ventura:        "abc717c7a971ea403c3adf6c858e096c125b1558ace34612c569c378fc3f9d90"
    sha256 cellar: :any_skip_relocation, monterey:       "afc3920b649de0abbbf4be6f9bccc8bbb3362a7c84dd0c551b38a4abc1f1f2ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3e094ec567c910e7dd4dae785979781a3cc6ebcc5e5b32f14447f1610f068be"
    sha256 cellar: :any_skip_relocation, catalina:       "edae797c19202bc52e73dd1c4f4e53609ef86693e63d536e26d5557f1c115edf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "903293ccfbd37369dca0458cfe533892a142cdc9418e46069b9d964f42c138c9"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/laurent22/massren").install buildpath.children
    cd "src/github.com/laurent22/massren" do
      system "go", "build", "-o", bin/"massren"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"massren", "--config", "editor", "nano"
    assert_match 'editor = "nano"', shell_output("#{bin}/massren --config")
  end
end
