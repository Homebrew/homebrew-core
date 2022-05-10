class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.81.1.tar.gz"
  sha256 "7aceb5ed51e0fcdbaeb9fc59050b35d304db8a211cf52b02d50309249dabe81d"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "013e07c7e975045f89888c5341431edbc2ab317f4afbf040966476e5c228004b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f50b2ec830664f560b48a8b29ab0562b1d13b71f8da678aea5ffc6f09570191c"
    sha256 cellar: :any_skip_relocation, monterey:       "2bed96c51cecc98468bc1685ef13c467c933fe3dfde0ceb068783a5ef248c1d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d1f26dfa54c8223d5eb505d281ff04c56c003f59d062dc7a35f34b707c999d8"
    sha256 cellar: :any_skip_relocation, catalina:       "dd9dd8fe3772954a06f4882a53918df5d0d8b6c31a36a4f0572c28204a4b727d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b74aa499bebca514db2ca12660fd28f74c430010b556e8074acc76d5d004adb"
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
