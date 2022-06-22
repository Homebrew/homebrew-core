class Hwatch < Formula
  desc "Modern alternative to the watch command"
  homepage "https://github.com/blacknon/hwatch"
  url "https://github.com/blacknon/hwatch/archive/refs/tags/0.3.6.tar.gz"
  sha256 "29478c9e8b5472540165f5f6e8a7b27f20f9a8ea3538d363725c1c6c4467ae23"
  license "MIT"
  head "https://github.com/blacknon/hwatch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66701800e379439109e0c092aac068cbd21a176f0e3aa5792f7795fe3d71ed59"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69a3237769b7ed644605bb2784f2d07f90078432ced2b6bb2ea651124995e725"
    sha256 cellar: :any_skip_relocation, monterey:       "9f21d461b648d4862d3b686b708c922d8891dc51fed2b56f56093b9c536ed985"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e3ed9522d16320179fef3e28fefb7736a1acbe816bd0d078bf15717015ad537"
    sha256 cellar: :any_skip_relocation, catalina:       "97d100b1262644c177382c3fd8651197eb200dd1c9db53300287676183540788"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a47586d29869a09e2012921e2adca9e7c3ded7bb4be3b8b2bf911ae95043fa4d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/hwatch.1"
    bash_completion.install "completion/bash/hwatch-completion.bash" => "hwatch"
    zsh_completion.install "completion/zsh/_hwatch"
    fish_completion.install "completion/fish/hwatch.fish"
  end

  test do
    begin
      pid = fork do
        system bin/"hwatch", "--interval", "1", "date"
      end
    ensure
      Process.kill("TERM", pid)
    end

    assert_match "hwatch #{version}", shell_output("#{bin}/hwatch --version")
  end
end
