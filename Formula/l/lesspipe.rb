class Lesspipe < Formula
  desc "Input filter for the pager less"
  homepage "https://www-zeuthen.desy.de/~friebel/unix/lesspipe.html"
  url "https://github.com/wofr06/lesspipe/archive/refs/tags/v2.13.tar.gz"
  sha256 "a9f3c9db18e766de6a0fb5d69cbd5b332ab61795c6fc3df2458e4bad1d38ae29"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6f45a126d1a0db0d36e1e1794e9b134880251c0a096c88c3f6b69abb508e203e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6887839d8d7dac9409005c021044738c749fd77bf9ce239c6193fe436d5ff459"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "598eede59a8c2d6db2180b41c46049a336d67c4de8f97ae86303496470742c0c"
    sha256 cellar: :any_skip_relocation, sonoma:         "e5dd22a4674ef552e146838360327e78cc47d6ad2dd2831339e154347218a727"
    sha256 cellar: :any_skip_relocation, ventura:        "fd6e9fe47fda65d7a7681b88b4eccf3e10aa66f467b7e899b72ffffea0c2781c"
    sha256 cellar: :any_skip_relocation, monterey:       "a79b80a27dff889999aa603a57ed0cb31c87f8e7b0e46142542090d9e3356daf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b13e53e0373195b31aecbc23f6cb2792cbd546497d6043dc8cede6c1f6eff1a5"
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
