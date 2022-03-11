class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.36.0.tar.gz"
  sha256 "5d35c32f16fb4f8e4f710aa31f4d68a5cb4011ee8960fa0ac6f3b7300b581e1b"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb07d0a20f25ec9f539c10b7ae43e78092d8236e52f873d98afc08741208a883"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d499b70138fee800574873255439ca2a959bc076e22a35efcaa1fbc69b5dc27b"
    sha256 cellar: :any_skip_relocation, monterey:       "40c921f020bcfdd61d9577c1f1fa5a552d1498fc794d1888ec25fc982529a34f"
    sha256 cellar: :any_skip_relocation, big_sur:        "0cc043fadfc492eb1f3b787219c094e48d6da26ec5cbce514f2ce4c23304039b"
    sha256 cellar: :any_skip_relocation, catalina:       "803b6ba8d6e9d69c79bb7cb10123dafaf60305a9ce79dc997f463ca2d0315172"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bffc95c4f6d9b84617e0460bc9875f1e6d6c2cdd716d7b08a013ff570bee0d0"
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
