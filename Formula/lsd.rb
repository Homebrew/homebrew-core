class Lsd < Formula
  desc "Clone of ls with colorful output, file type icons, and more"
  homepage "https://github.com/Peltoche/lsd"
  url "https://github.com/Peltoche/lsd/archive/0.21.0.tar.gz"
  sha256 "f500c18221f9c3fd45f88f6f764001e99cf9d6d74af9172cbb9a9ff32f3e5c7d"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb1ae021488b265d2f05e71b9c1b79ffa6113c2cac1f77e7287b9525315add2b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "706fdc3ceb41d2ad2ebdbc11b3930d87c5546d109331c9b965cb7d29875bd100"
    sha256 cellar: :any_skip_relocation, monterey:       "1b8a883d68c3ea85695a5e33602e99b3d6f8866f34444eeedbb4d9131112af90"
    sha256 cellar: :any_skip_relocation, big_sur:        "d14efa8c804908f25d88f0cea0ecea253d6a059d971de1f630ffb29af2f691d8"
    sha256 cellar: :any_skip_relocation, catalina:       "b42295c9884214ecf4e6afc90aca429d739cd509f72f54e8ee590e6afc26aed4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90f92d5c4d38f5c3e84c13bc171c3bdae04f50da02a7fc2bd6680ea82368f3fe"
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args
    bash_completion.install "lsd.bash"
    fish_completion.install "lsd.fish"
    zsh_completion.install "_lsd"
  end

  test do
    output = shell_output("#{bin}/lsd -l #{prefix}")
    assert_match "README.md", output
  end
end
