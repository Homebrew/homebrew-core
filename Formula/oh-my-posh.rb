class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.18.0.tar.gz"
  sha256 "ed38d4613b5db07f0b00ae3a8fdf4597601edbaa093d598a0c0270e755382a03"
  license "GPL-3.0-only"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d11ca81148a17fdeb57eb56035ecf5828f99dd499fa587513a81001a23e2128"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "511ae2937e25634142a7fa36ae7910ce96b92047bbc997c75b6bf65ef2c9fc9f"
    sha256 cellar: :any_skip_relocation, monterey:       "dbe8641b8ffa936f9a56952be15ebd304ccc490e9425d286455f125cfb983ffa"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec1fb28f038cd74f18db3b3530b754764e0ee59cdb51cb291a3f42ea135224ee"
    sha256 cellar: :any_skip_relocation, catalina:       "fb2d253e3111e6ad02f6450f50afebfc8bffbd1866da2d8e9293c5bbb7973d3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03bd7155ea747adfa2474317e0b9f66313f92e2dc64b0a49104ce8e893ea0571"
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
