class Lf < Formula
  desc "Terminal file manager"
  homepage "https://godoc.org/github.com/gokcehan/lf"
  url "https://github.com/gokcehan/lf/archive/r24.tar.gz"
  sha256 "252e7fda36b874260e78285ddad1e4d8001cc1a40fcc27812ef155bbb10d9855"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "16d811e711ad5745ac5874edaee43201bad597c9af4bc1a592784a36a30ce87c"
    sha256 cellar: :any_skip_relocation, big_sur:       "dcc1e1c8a031aafc832afd88ae862cba11e40ea69b8b684be06d80f3ff819a76"
    sha256 cellar: :any_skip_relocation, catalina:      "eed6615cc7ec0d5a5d02b918531cd4528384d4a2542fb079b91e6a95ae6bb78e"
    sha256 cellar: :any_skip_relocation, mojave:        "ca492fef3056adc20e79d02653737ab41c3415df7ada075d14a0384cf6cece9f"
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
