class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.19.3.tar.gz"
  sha256 "44a3a2615dcbeba3e1d84b597549f0d013e7c45c87fbac9ef2d93289790f30c2"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79b7b751cac583edd9c22102a4c14c71a064aec268e52f5be1021e39f19c9235"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f8bb073bb55eda4184dcb158b96d13088394f09196f9502fbbedd3ff4cbd5fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fede24d6d7ee494f66401e17675cdd464355e481b48471a9f33b48cb418aeaf7"
    sha256 cellar: :any_skip_relocation, ventura:        "74735f64eb197e71a880f84e2fe5fbc7bd71ff36a791135bc6c15ad4b5ddcf2e"
    sha256 cellar: :any_skip_relocation, monterey:       "304fd2b83df90a1549be115663d3e527ed3f5e907210ec873e0cf4c64f9a95ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba61d2b79c9c6e6e3776795c647a2e968094618cc544ed0cbd66516ef94bd6f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8177dd881d2d989d2e88b6b2a68acf0d97c75dca27ae0303e1a57167bd86c919"
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
