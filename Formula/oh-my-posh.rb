class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.77.0.tar.gz"
  sha256 "aceeafd3730b0460e82e0cffaf238158f07b2b5a95314d100693481637341b69"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81c2f8cdeb3ecc7368560d6fa40a6737093f2fd700f0cc17aab8a2842d3d6486"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b33f872fd5968af7c0899712e8916d55239325e666925bc34ceec5a267c34711"
    sha256 cellar: :any_skip_relocation, monterey:       "b12872c6bc2dae382e53f6950800ad0da753c5338b8ddb660b79fda72c4fe71d"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc3aada585152846dfa50fcbe84118cf20e1dfff8f3cafbf698c3ec7e7fb7cb4"
    sha256 cellar: :any_skip_relocation, catalina:       "4a4773b7a927dd94ada15d21a7ac258d059ba506fd8c1fb5be3fd85dc97c0678"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53bbb4a39e5d7e4443c922453bd15581a1d32ff23409af9923a543f29c8d4d58"
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
