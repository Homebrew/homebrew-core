class Lf < Formula
  desc "Terminal file manager"
  homepage "https://godoc.org/github.com/gokcehan/lf"
  url "https://github.com/gokcehan/lf/archive/refs/tags/r42.tar.gz"
  sha256 "7a8f7c2c86419270b713b6235dced7b9d0e68732e74a1e0f375f774fff4023ca"
  license "MIT"
  head "https://github.com/gokcehan/lf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "192ce9e768f94964a0775998e22fe9fde5fe23124e6e1b55abcad66528bb66b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "192ce9e768f94964a0775998e22fe9fde5fe23124e6e1b55abcad66528bb66b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "192ce9e768f94964a0775998e22fe9fde5fe23124e6e1b55abcad66528bb66b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "46ff0b621e97d09d11159977ec9f5b37a5aca50cac2866efb8077ec351f08632"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eaf796f2562b6704399a09b73a68b10eb6517109b7e8572c2773da2c036a813c"
    sha256 cellar: :any,                 x86_64_linux:  "3c7216ba031c5c7181e59c3584be52cfa6d5d1ab2545b04cf56bb08114e4e220"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.gVersion=#{version}")

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
