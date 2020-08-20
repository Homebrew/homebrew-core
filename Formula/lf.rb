class Lf < Formula
  desc "Terminal file manager"
  homepage "https://godoc.org/github.com/gokcehan/lf"
  url "https://github.com/gokcehan/lf/archive/r16.tar.gz"
  sha256 "92031b31c194f0af11fc0f00d575db0dc9bb2c6c80bccc73fa19de02e82d00b1"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "18284a4548720bcc4664a9b07b51d37b7c755c013a290be501ea8127cb96fb56" => :catalina
    sha256 "7bf885e9a0e6fece97da83c2162ec8afab70716c41bd39de92e6ef71f9309bed" => :mojave
    sha256 "6b33c66595717bd0401004d8dc2ffdb4f98a9bd5a818743e7e3ad5c853e77941" => :high_sierra
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
