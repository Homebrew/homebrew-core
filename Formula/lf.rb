class Lf < Formula
  desc "Terminal file manager"
  homepage "https://godoc.org/github.com/gokcehan/lf"
  url "https://github.com/gokcehan/lf/archive/r20.tar.gz"
  sha256 "b0d755e255d48229c14b7ec5f86788c6fc96df1f6859f677b313fd9deb856398"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "76532aef2662851d91c21fec4e461f59d7e5ff34c29a1932b67a736df63614b6"
    sha256 cellar: :any_skip_relocation, big_sur:       "97eaf299413c09cbce0467da36ab94b572686b677bd29875280f007f8d02a59b"
    sha256 cellar: :any_skip_relocation, catalina:      "91f1f834f8c148b7672013ef1daf2b622d98fc436d1456c7de046a0a999c0cb1"
    sha256 cellar: :any_skip_relocation, mojave:        "12783fd218c49b0c221b7ab2bb1caebfbb55628441d147642c08f1467aa5dda2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.gVersion=#{version}"
    man1.install "lf.1"
    zsh_completion.install "etc/lf.zsh" => "_lf"
    fish_completion.install "etc/lf.fish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/lf -version").chomp
    assert_match "file manager", shell_output("#{bin}/lf -doc")
  end
end
