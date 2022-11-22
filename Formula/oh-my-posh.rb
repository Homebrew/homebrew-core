class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.17.2.tar.gz"
  sha256 "91c4efad5f274e5ef6c8c7d67e4c9e13abea06f176f7d1eafc5a2f37bf4ab85a"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3600b6d686e683b82f90404bf61be49468f23565683969df7e668d6f38e9be0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9705be59f0950f1d402f1feb63b8456a5d64cf5791c837f9d73dfa3690c7e553"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b081cd37cbca8deb969b800f3a8a32201004c6110f09de1cb05a229bf3189f42"
    sha256 cellar: :any_skip_relocation, monterey:       "d2ab102b5f024c73f1ff77ed69bc53df6dc8575f694a2b0880590c5c4fb9e751"
    sha256 cellar: :any_skip_relocation, big_sur:        "46eec3b5043d93156381c5513cd4b11cfcd7c0174ba7a8319dde38bc3447a687"
    sha256 cellar: :any_skip_relocation, catalina:       "d14ac1d6964cd275b9cc839acb07c5345f67f86529ad67da411e67807e5fe9e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0edde4c2f218dc3b4937b4223e2c2f0b25cc96907b1e844e8c4ab43b134aabff"
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
