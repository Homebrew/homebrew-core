class Lesspipe < Formula
  desc "Input filter for the pager less"
  homepage "https://www-zeuthen.desy.de/~friebel/unix/lesspipe.html"
  url "https://github.com/wofr06/lesspipe/archive/v2.08.tar.gz"
  sha256 "91b1363ba9b5594fa4285717592d712a6c724ae7ee35a9543127b3d64677c0d2"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d5acbe4e5584844585a9680028b6ca2fff44f32aa6cb9a28eef05c5dfba2b72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d5acbe4e5584844585a9680028b6ca2fff44f32aa6cb9a28eef05c5dfba2b72"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d5acbe4e5584844585a9680028b6ca2fff44f32aa6cb9a28eef05c5dfba2b72"
    sha256 cellar: :any_skip_relocation, ventura:        "7d5acbe4e5584844585a9680028b6ca2fff44f32aa6cb9a28eef05c5dfba2b72"
    sha256 cellar: :any_skip_relocation, monterey:       "7d5acbe4e5584844585a9680028b6ca2fff44f32aa6cb9a28eef05c5dfba2b72"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d5acbe4e5584844585a9680028b6ca2fff44f32aa6cb9a28eef05c5dfba2b72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a69bc6598722e59c9fcc261d36d2baf78e90ceb85c190030aeb8aca4ba3ab68"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    man1.mkpath
    system "make", "install"
  end

  def caveats
    <<~EOS
      add the following to your shell profile e.g. ~/.profile or ~/.zshrc:
        export LESSOPEN="|#{HOMEBREW_PREFIX}/bin/lesspipe.sh %s"
    EOS
  end

  test do
    touch "file1.txt"
    touch "file2.txt"
    system "tar", "-cvzf", "homebrew.tar.gz", "file1.txt", "file2.txt"

    assert_predicate testpath/"homebrew.tar.gz", :exist?
    assert_match "file2.txt", pipe_output(bin/"archive_color", shell_output("tar -tvzf homebrew.tar.gz"))
  end
end
