class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.19.0.tar.gz"
  sha256 "6213f9748ec14c568b7ecd497a436d2a9b86100730c513a9283b13453a5cfc6e"
  license "GPL-3.0-only"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd992a926b0efcba7c114bc9fc19aaa56c056cdfac62d841c1dd3001ff2ceea9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4d0e9f275b7ddd7b832abc0a8f20f62263dbdd8be9483f4a7e4d06e9c604aa1"
    sha256 cellar: :any_skip_relocation, monterey:       "e92edf0cbc2a4b5c33eebf1bfccba1e1bde1009f556b0a228af15538314ece92"
    sha256 cellar: :any_skip_relocation, big_sur:        "141ff5be60e47807b40953d3932bd3ce79209a384737e6b56c0e50d8bf0c395e"
    sha256 cellar: :any_skip_relocation, catalina:       "28a2371fa2ac8683dabf19284ca87cfafc0fede545d8f1a98920a11a9dfba369"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b19b02483208798addd8959910ba26d7196a3250bbe146e9cd66f528d64d2dfa"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end
    pkgshare.install "themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end
