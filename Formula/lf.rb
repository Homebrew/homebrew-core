class Lf < Formula
  desc "Terminal file manager"
  homepage "https://godoc.org/github.com/gokcehan/lf"
  url "https://github.com/gokcehan/lf/archive/r18.tar.gz"
  sha256 "b9aba66ee8f0ca8229d4d3c0956fa7a7fd71a7e099e119d5609d29a1d9019344"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "1fdb7e34f3790bc00e746e0a09615df05630f3bd7fcd0c52e45163d3e32d9ea0" => :big_sur
    sha256 "577b07faf529ac6934b52a8c34453d76865938876b34ad8c860e14fbec5732b6" => :catalina
    sha256 "7381c831dc9444b1b151d6b9c8bb8d4c6a8bf0030ebf6dee7fa0e34b00b5a78b" => :mojave
    sha256 "6231de35fbdbc59be8ce3fb69cd5e87fee84dbfcb5aa81300835900109cc8161" => :high_sierra
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
