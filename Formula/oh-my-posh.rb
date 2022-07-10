class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.15.1.tar.gz"
  sha256 "5528cab880f66a527c923ae5bb89d9aec8a142d53737af8be8f65ec45ba81a1c"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e83d2bf6eef6b4f783da1c4b8065ab00a386ec1bae446d6a21682d448f2d1dce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0f8d3aa3044f6d2a93f726ee3fa01b4199cac4075c746cac18104bb5cc4c634"
    sha256 cellar: :any_skip_relocation, monterey:       "697025025344acfed93328e9d9ba737efc1ef461a019ef0820ec01188a4bc10b"
    sha256 cellar: :any_skip_relocation, big_sur:        "78fc2007226028f4d4afde8299bf8233d7f8c88231dd09843eb137c24c4c46cd"
    sha256 cellar: :any_skip_relocation, catalina:       "a56a47bc686805bc63d226557ddde30860c0efd0dc17888c725b14a73f6c2a61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fa99c0d64c30355d97bf64d8f036da9fb4fb91ad6584ca3b5e422c0fb8794c1"
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
