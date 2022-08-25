class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.33.2.tar.gz"
  sha256 "4d91309bd01125965b80ed5f47073a61e955e715f371584fd7801f2a3dc4cdce"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3036f783fc2a13802a2b76167b294a9d28c34a1916d3925ceab3ba6be48fe392"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad8f899c0e25ef2341dd17a1bdff5bdfa3be1982e5c2bbbf73e4f3e006383038"
    sha256 cellar: :any_skip_relocation, monterey:       "36f7ecd57b9d7cd03d345e43f1ca9cf8b8def92f6be7231b55717da4210b56ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8fada701bb3c34db729cc4404dc84b2873ca44ba337935f85f35a08cefafcad"
    sha256 cellar: :any_skip_relocation, catalina:       "630dd74318a278c0feb153c6cf9f274593d897e99e9c85abaafe1ce72377f9ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "456c50de49df84d9d9044e7627b10a05ad2b84ed2fcaef214c377fded339d70c"
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
