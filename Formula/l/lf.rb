class Lf < Formula
  desc "Terminal file manager"
  homepage "https://godoc.org/github.com/gokcehan/lf"
  url "https://github.com/gokcehan/lf/archive/refs/tags/r41.tar.gz"
  sha256 "55c556d53b5541d5f8691f1309a0166a7a0d8e06cb051c3030c2cd7d8abc6789"
  license "MIT"
  head "https://github.com/gokcehan/lf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0614ed4032dfb16c5d420b1a45de4df073a5fe96ecd707065f66896eae3c86f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0614ed4032dfb16c5d420b1a45de4df073a5fe96ecd707065f66896eae3c86f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0614ed4032dfb16c5d420b1a45de4df073a5fe96ecd707065f66896eae3c86f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "52277c0b4e6e2b2940a495a845d8763be4cdd13752639183b6693a19aa37d8fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb678371b96adea7927bd147af8242d7002350bc2465ba186445df0aa4947b09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fca1291939ad6be0337c0154638cbe4c5a4fad868390ed472f5020999ffb4671"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.gVersion=#{version}")

    man1.install "lf.1"
    bash_completion.install "etc/lf.bash" => "lf"
    fish_completion.install "etc/lf.fish"
    zsh_completion.install "etc/lf.zsh" => "_lf"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/lf -version").chomp
    assert_match "file manager", shell_output("#{bin}/lf -doc")
  end
end
