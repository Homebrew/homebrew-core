class Lf < Formula
  desc "Terminal file manager"
  homepage "https://godoc.org/github.com/gokcehan/lf"
  url "https://github.com/gokcehan/lf/archive/refs/tags/r32.tar.gz"
  sha256 "01531e7a78d8bfbe14739072e93446d003f0e4ce12032a26671fa326b73bc911"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3e322a8696a35d40b3fa538d21f21c02b3095cd64c5050b3f48bdc1ecad9b0c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d11f97b9b0f5394410b3a7323edfa62e149cb82d9dfe51648335e3c8a0cfe59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c699f29df62cf585355f81d4b0bd44c4922e71f571bc4165b03a5dfdb9e1b592"
    sha256 cellar: :any_skip_relocation, sonoma:         "986abd93ab80942ac7beaefd4ee77e75ffd3e4e61beef0bc20b462e1d7ae0a7e"
    sha256 cellar: :any_skip_relocation, ventura:        "c4e329915694e9ae94f89bd069d4273c6cf7fa83d1c42f1f8930adb4d8f47fd4"
    sha256 cellar: :any_skip_relocation, monterey:       "67af5e41af9b30509cd4a32b8612b7af7ba4e8bc2de73e68caa00d5dd8c17f92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b74e1e028f3c6b0d1fa3fd6da1ac750fecf0295a9997533e959e4e46a50108c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.gVersion=#{version}")
    man1.install "lf.1"
    zsh_completion.install "etc/lf.zsh" => "_lf"
    fish_completion.install "etc/lf.fish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/lf -version").chomp
    assert_match "file manager", shell_output("#{bin}/lf -doc")
  end
end
