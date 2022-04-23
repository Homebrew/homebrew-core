class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.70.1.tar.gz"
  sha256 "f45938019e98e3f7027745af15aab898339895057b23559a5ede5d959f1f7016"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f34a04b563ae4426800e9fcafd1135699ae02598ad3df56c2e2330faf6da2433"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "590009f1fb33702b1defadf3061a483cdbe4706175bc84a8dfb86605d6d5a55b"
    sha256 cellar: :any_skip_relocation, monterey:       "611d30250e4b3cbe236d8e2f423dbf090a1e4fdf395ffe97085caf2cae71e1fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c1f64ce0d0e7077099eebe5c3f870c632498f281b7c1b9946a1767ee7258596"
    sha256 cellar: :any_skip_relocation, catalina:       "84e437176e72afe508f84d4c60821eaf54a4dc9d80e6d6302b77b6f4fb5cf6a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07b16a21469ff2856d2bbe2fee39b12912bfb13ec471b1eb933f37feb907690e"
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
