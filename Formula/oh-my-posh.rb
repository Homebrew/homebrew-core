class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.30.0.tar.gz"
  sha256 "914be57656d93d181198f0a11683b7cad77b9a9d272445f2c4d61dcf5d4a8181"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92b02a2091e4fdc39c893786da9f342c55c9c3ade140fc7ceb46cc24a8efbe97"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3967cc9cc4288c59152b36401d80ad65b8867df9e39946a324c3bcf3739fbec4"
    sha256 cellar: :any_skip_relocation, monterey:       "5cfee5f942a032e2a6ab6fe90507d21718af104853de955596c72a1327683288"
    sha256 cellar: :any_skip_relocation, big_sur:        "329e80cc9c56c040ebd50271f2f01096b8d97e5198fd5880335d5098787b283b"
    sha256 cellar: :any_skip_relocation, catalina:       "dc7fea30038cf635531d753340ecfe8f7ce78e09f9158aadac4f99c60d78ab3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09c736398d1e10b8977ae0536be56e1d7eda7f5ff4243728d3bfe2b1bb91a337"
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

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end
