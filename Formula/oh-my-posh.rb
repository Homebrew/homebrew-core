class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.79.0.tar.gz"
  sha256 "70c9b6206a51c0ddeab1ef40739966d64f1a59461deeb380a1aa31512c429c46"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ece0255477c50567614aad6f79ebbbcffc55df4c020c2fa751899b78cbe1a552"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cfd253c06d7d8a90bae56dee657a4354bc4a36573c0502c9c926a48851fcce1c"
    sha256 cellar: :any_skip_relocation, monterey:       "2e1dc87fce39cb1e4677bd2e9e29e5911ec5ada7c0a3c0abbcd84accd2e58939"
    sha256 cellar: :any_skip_relocation, big_sur:        "53137f1fc3cfc07add55a4874853431df175280d1b24c9e215c00620d5e37cdf"
    sha256 cellar: :any_skip_relocation, catalina:       "0401a04cf2ef9592c851a471ede961d709ab211121590834c21a6824e020ee99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e599e3ced2c0452bdfccec6374ce5a725e579b2efbb6d2993f294dff8ac35095"
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
