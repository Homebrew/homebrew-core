class Lf < Formula
  desc "Terminal file manager"
  homepage "https://godoc.org/github.com/gokcehan/lf"
  url "https://github.com/gokcehan/lf/archive/r30.tar.gz"
  sha256 "6f8bc88797710926867a74f3ef68e408e05758bb399266d2841bf0d341d4c146"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0b6538faae601fc2a199787ab0253b84948243564788416a25ff93cc27424a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0b6538faae601fc2a199787ab0253b84948243564788416a25ff93cc27424a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0b6538faae601fc2a199787ab0253b84948243564788416a25ff93cc27424a3"
    sha256 cellar: :any_skip_relocation, ventura:        "4e11b1688cbe8a782bb120e799854405f3923d3a0d72b22f5a72fc04544941b1"
    sha256 cellar: :any_skip_relocation, monterey:       "4e11b1688cbe8a782bb120e799854405f3923d3a0d72b22f5a72fc04544941b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e11b1688cbe8a782bb120e799854405f3923d3a0d72b22f5a72fc04544941b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c271148f4e81ca417f45174f79e05413882de5f60290d169d338c8243da56c83"
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
