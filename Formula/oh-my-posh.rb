class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.33.0.tar.gz"
  sha256 "b78dba9f5b544ad509dfd9eb243508b7f7e75fe9c66410dc48cbe92a2c2704b7"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc9a1cdc25c20533398dd46dd98efeae186984113a9621de2e9b69d5efa3b039"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "705c72faaee676f2d06c47750a9b6ced65165b558c233485601637ebc77f7162"
    sha256 cellar: :any_skip_relocation, monterey:       "e1fdc24894c5c80771b4fe84632a88a676fbe32afb59d66def0ebe2d53a18c62"
    sha256 cellar: :any_skip_relocation, big_sur:        "81c32ce45c8b258417008a14b313353a1775cf2ed5b3012bf3126741f6f97656"
    sha256 cellar: :any_skip_relocation, catalina:       "2f050be0f8a3ffc5801cddbb8c91a3ffa5ced8467d992de0fd80aef99af85fda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0706fb1ab6b7793dca0c9abff0b2f1d7777f2d0e086438af0abf69f5d8fa9abc"
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
