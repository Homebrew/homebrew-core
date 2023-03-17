class Naabu < Formula
  desc "Fast port scanner"
  homepage "https://github.com/projectdiscovery/naabu"
  url "https://github.com/projectdiscovery/naabu/archive/v2.1.3.tar.gz"
  sha256 "a8d46cde4b0f0cd6491b5c76dbd8a68dfc9480171dab4a88a05cef679d476a52"
  license "MIT"
  head "https://github.com/projectdiscovery/naabu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6ad2673dc4c308699a539a7a964d71822091c5e6a478efb2c0ae8f597309d0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a62a98b9c1fdc6ef115e1ab5b1bbf1bec14c199056c4ec39ce284b4989eb8a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83b1cf9c5f83c7a9e87319c84ac19e98e6aa125b63cb732f8007b41f6175606c"
    sha256 cellar: :any_skip_relocation, ventura:        "3b4743c68275ff33a22d9eaeb5f1b240874f47496815770c5f18ce3e38a6f9d7"
    sha256 cellar: :any_skip_relocation, monterey:       "920af9ed7d0b51a440ff380b3d3e198598b6688a5c7cc9e895ec7e8add7360aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "fdca18f5a22aca107e486dfe873026f5e4a357e1906e79f4812343899c64e972"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "069a207be7c10ff42e096381fe27972e60ebe51225523ff0f23cfb6e4993f497"
  end

  depends_on "go" => :build

  uses_from_macos "libpcap"

  def install
    cd "v2" do
      system "go", "build", *std_go_args, "./cmd/naabu"
    end
  end

  test do
    assert_match "brew.sh:443", shell_output("#{bin}/naabu -host brew.sh -p 443")
  end
end
