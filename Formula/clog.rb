class Clog < Formula
  desc "Colorized pattern-matching log tail utility."
  homepage "https://taskwarrior.org/docs/clog/"
  url "https://tasktools.org/download/clog-1.3.0.tar.gz"
  sha256 "fed44a8d398790ab0cf426c1b006e7246e20f3fcd56c0ec4132d24b05d5d2018"
  head "https://git.tasktools.org/scm/ut/clog.git", :branch => "1.4.0", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "97e07b94ea058c766f4d036cc503fc6ec08ca64cddced33d63723e4611534595" => :sierra
    sha256 "8f42168b8e165c4c1f1265b410ef62087b370075cc27269f1908eb0f373645c5" => :el_capitan
    sha256 "a6c42c7d0795252434a3e1fc0307fc40490a4f29a9186408fa3ed7d82ba5f02e" => :yosemite
    sha256 "61ce3b9c332f9487f9981d8bb93d62fd4b6dfd0bbf0aa8f680b3fd625b2d8576" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    Next step is to create a .clogrc file in your home directory. See 'man clog'
    for details and a sample file.
    EOS
  end

  test do
    # Create a rule to suppress any line containing the word 'ignore'
    (testpath/".clogrc").write "default rule /ignore/       --> suppress"

    # Test to ensure that a line that does not match the above rule is not suppressed
    assert_equal "do not suppress", pipe_output("#{bin}/clog --file #{testpath}/.clogrc", "do not suppress").chomp

    # Test to ensure that a line that matches the above rule is suppressed
    assert_equal "", pipe_output("#{bin}/clog --file #{testpath}/.clogrc", "ignore this line").chomp
  end
end
