class Lesspipe < Formula
  desc "Input filter for the pager less"
  homepage "https://www-zeuthen.desy.de/~friebel/unix/lesspipe.html"
  url "https://github.com/wofr06/lesspipe/archive/refs/tags/v2.14.tar.gz"
  sha256 "8da921f34b428f6347a37c36b167a523bbacada7dbdd952b708f554012867b67"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "91c2d6f7b2356753e6cbb6a72c4058ac55d468220eff5543a2cfe19d48cbf3d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91c2d6f7b2356753e6cbb6a72c4058ac55d468220eff5543a2cfe19d48cbf3d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91c2d6f7b2356753e6cbb6a72c4058ac55d468220eff5543a2cfe19d48cbf3d6"
    sha256 cellar: :any_skip_relocation, sonoma:         "91c2d6f7b2356753e6cbb6a72c4058ac55d468220eff5543a2cfe19d48cbf3d6"
    sha256 cellar: :any_skip_relocation, ventura:        "91c2d6f7b2356753e6cbb6a72c4058ac55d468220eff5543a2cfe19d48cbf3d6"
    sha256 cellar: :any_skip_relocation, monterey:       "91c2d6f7b2356753e6cbb6a72c4058ac55d468220eff5543a2cfe19d48cbf3d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "841c9956e8a455c825a19c36539a371b9be6dbd7164fd375fb71ac680d88b33e"
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
