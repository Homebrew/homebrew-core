class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.13.0.tar.gz"
  sha256 "978431e4693fb2acd00a841dfdb294f85eff9951299c7bafc76f1116575e1ad2"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c1904529a40fad7c356834829185c12113b4ff8ce79fa628c4e3dc5f40c2b50"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2cb376e27fa4d5b65f824d3f0fa3501f49ac4d53647d54968921f1086d48423"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f43094d1e44b11e7c73e87d94996da4859f99468c18b4e7c7811ac4ac96c4c2"
    sha256 cellar: :any_skip_relocation, monterey:       "2abd75a763ab1b1e195934e4e3165f7e3e31225d7b31897c9ef99d9fe53001fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "11740a0e98d8da5a0d60451b27c40386e17c0186ad106d07e2f1b2731c03d222"
    sha256 cellar: :any_skip_relocation, catalina:       "3a44caa37e08de1f1e6de46200dfd9599edcf4950b75953f734fd693b8610c4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6f7412da542dd264573e8e9f13c2fa2173070741d1601bd53481316e5836500"
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
