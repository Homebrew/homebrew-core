class Lf < Formula
  desc "Terminal file manager"
  homepage "https://godoc.org/github.com/gokcehan/lf"
  url "https://github.com/gokcehan/lf/archive/r15.tar.gz"
  sha256 "e389a3853ce02ffcab9de635cbe456e6fdc5c1696c9585614d80bb0fae88b27d"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "d53611f5c7f78e947eeed932abd4cd64591b416815043e62c971257f1d300cd7" => :catalina
    sha256 "9d08c5d7c877993c3a47108fa36f27290c16fd92e198aaff4ab8494a92337f8a" => :mojave
    sha256 "6d4f60d4005731fa3c0851caed566add13a11899271523c6815f88b0907e8c1c" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.gVersion=#{version}"
    man1.install "lf.1"
    zsh_completion.install "etc/lf.zsh" => "_lf"
    fish_completion.install "etc/lf.fish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/lf -version").chomp
    assert_match "file manager", shell_output("#{bin}/lf -doc")
  end
end
