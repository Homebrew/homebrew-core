class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.6.6.tar.gz"
  sha256 "724e760e18cdca0757b86b33e9efe947075f0074448cc35eb93caf70423b2d76"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fe1942f046007ecf1efd2726c5a8b21c0db4894a54b4b6ed7d25c3bfd57e08a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6eac405bb978166aeb03262dd12ee8049a16ee8e8e33f2f197ad6cf2ab19bca7"
    sha256 cellar: :any_skip_relocation, monterey:       "d5eed600dfe74eed5b0ed86f0f615f1e495fdbe0320a1e2df53916619df2da35"
    sha256 cellar: :any_skip_relocation, big_sur:        "bfa5fc11ca8f4c5edf92b859089f923c7545713046b8d1755d8a3f2da695cc49"
    sha256 cellar: :any_skip_relocation, catalina:       "4aecca751ef5b28eaf0c852486603188af9fd110d52f93887a7286d7633d8855"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43bf2322ff2d3ae878ef6b3456981ce4759b9ae0971b9397f84ce06d093202db"
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
