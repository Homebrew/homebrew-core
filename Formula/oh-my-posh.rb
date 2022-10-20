class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.6.0.tar.gz"
  sha256 "3a8e1037317edb82a6d68ae552f2e094876db23c86f97a04925429c5d78263c0"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c153526fca636ed36997750ded4249a0bff5287f59eceeb588b145a733099563"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d032aa14afa05254463a7d6e0f7447eaf0d49b8d0d0dfe984f94b236230ba85"
    sha256 cellar: :any_skip_relocation, monterey:       "b25c20a4b64fc74b7acf526ead2ea7af8584a0157a0da12d1ce97ee64cb438b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "66154983d841fa81e4a6d4961e5652e6e9fa0be54c8a423615877aec7549da04"
    sha256 cellar: :any_skip_relocation, catalina:       "7330b717ec2d4d2549b54861c8a81d6d2a213de92b29f64a7d06074584aeacbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "597d3be1e0d47aac3e22d0f8cda9760bb18e0e29db9bfda8f414293d7f256576"
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
