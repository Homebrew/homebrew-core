class Lesspipe < Formula
  desc "Input filter for the pager less"
  homepage "https://www-zeuthen.desy.de/~friebel/unix/lesspipe.html"
  url "https://github.com/wofr06/lesspipe/archive/1.88.tar.gz"
  sha256 "442a178f40e0261144f03f1a31048e00d09c8d0fbd7107d99d183b54f10c7ac3"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a7800c858d9cad5be753c313c5da1f33a4c9d89507b6e8adb26a2ca2f7d68c42"
    sha256 cellar: :any_skip_relocation, big_sur:       "a7800c858d9cad5be753c313c5da1f33a4c9d89507b6e8adb26a2ca2f7d68c42"
    sha256 cellar: :any_skip_relocation, catalina:      "a7800c858d9cad5be753c313c5da1f33a4c9d89507b6e8adb26a2ca2f7d68c42"
    sha256 cellar: :any_skip_relocation, mojave:        "a7800c858d9cad5be753c313c5da1f33a4c9d89507b6e8adb26a2ca2f7d68c42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4262dc33731a301fefba943fee0744cd7e3d9fb8d90ab00cde86ff2a09675e34"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--yes"
    man1.mkpath
    system "make", "install"
  end

  def caveats
    <<~EOS
      Append the following to your #{shell_profile}:
      export LESSOPEN="|#{HOMEBREW_PREFIX}/bin/lesspipe.sh %s" LESS_ADVANCED_PREPROCESSOR=1
    EOS
  end

  test do
    touch "file1.txt"
    touch "file2.txt"
    system "tar", "-cvzf", "homebrew.tar.gz", "file1.txt", "file2.txt"

    assert_predicate testpath/"homebrew.tar.gz", :exist?
    assert_match "file2.txt", pipe_output(bin/"tarcolor", shell_output("tar -tvzf homebrew.tar.gz"))
  end
end
