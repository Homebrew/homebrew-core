class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.85.0.tar.gz"
  sha256 "a6f547d5aee24c7f3824afa3de1ab4ebc6882448454d642f2037c2149cd9063d"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "524a9b45656c65907cac25dddaf82de3e78f0f002cc9594440bcbf780a591753"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5dadc7c02cf378202df01704e4d45294200e263df1b38997a855f7147f8f22cf"
    sha256 cellar: :any_skip_relocation, monterey:       "f3b54c9a421156241f9e8269297629afb050a1200f19e84fc5a2a5c5f32615b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "47b1068d5116c5ad6c86d026d16004f8ac44e072a521319e7092dbe148788095"
    sha256 cellar: :any_skip_relocation, catalina:       "61e959d22711290a80db6ddd079011f33f940a9ca07d5e6ab60ec689d68440eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8c492ab102ea42cacbac2f33f7341f07e3a8841e4586701304fc9a01d0a5e76"
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
