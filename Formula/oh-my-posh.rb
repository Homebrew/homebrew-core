class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.46.2.tar.gz"
  sha256 "31c1c5bda9e169c17403854f728dbf29630c7bf5c08d4f221b4c870f539a0f75"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19d210c1e66b78a5fc4447d6d596be195658d803a16d2bb1090b20d146406f43"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9d492cd17e497f2328b784d48dd26c11b0b28cb92e96d996af08ec746565af6"
    sha256 cellar: :any_skip_relocation, monterey:       "7dcdf7563f751b19dd360a554ffa5a436159ad11f9ff4e7f22d2e954bd812c47"
    sha256 cellar: :any_skip_relocation, big_sur:        "90b2f97db19ee051bb66664492e7004dfde0d29e69cae05eab75c39f3ab2d9b7"
    sha256 cellar: :any_skip_relocation, catalina:       "bcb71dea2b3509a5653e881e35480c4a951c498f1dd8b9a544925ab9d67f3a85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "417a59d1c219d4f64d97abaf7747d8e2187b2f664717ebdff892daf2c5959e2b"
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
