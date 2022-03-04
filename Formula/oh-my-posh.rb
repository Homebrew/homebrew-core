class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.31.1.tar.gz"
  sha256 "7a2a23e8f2e8354afbc917bead074b06ee68955e921703cdd0da35a746b7a1e2"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4d5289291f255855f42990edb00884e16a9f6c9e47dd11bed1b88a89f5ae8f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "61ff38e8d0e1cdd29c2ab0a9d2a4b1056ea4f9982e0898c4839984d3e36279e9"
    sha256 cellar: :any_skip_relocation, monterey:       "3ed1c63041ac21ad47b080ee41bb35f9c4d84f0d6385bad37a889a10598caed5"
    sha256 cellar: :any_skip_relocation, big_sur:        "68818a81f37b787a230d5136686f230151d4966de7da87e5342fa3c855f6c0d5"
    sha256 cellar: :any_skip_relocation, catalina:       "c4a42fd578bc032939e67729c190bb87f408a380286a8c8d344b2485b68bda46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "091ed69e73829f384601979763963c43778920e89648a411ac79528ca9702895"
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
