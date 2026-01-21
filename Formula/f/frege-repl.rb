class FregeRepl < Formula
  desc "REPL (read-eval-print loop) for Frege"
  homepage "https://github.com/Frege/frege-repl"
  url "https://github.com/Frege/frege-repl/releases/download/1.4-SNAPSHOT/frege-repl-1.4-SNAPSHOT.zip"
  version "1.4-SNAPSHOT"
  sha256 "2ca5f13bc5efaf8515381e8cdf99b4d4017264a462a30366a873cb54cc4f4640"
  license "BSD-3-Clause"
  revision 2

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "f68a61801c7e99908489f6339d178107252377a08db65607849027d869df9bd0"
  end

  # TODO: Switch to `openjdk` on next release.
  depends_on "openjdk@17"

  def install
    rm(Dir["bin/*.bat"])
    libexec.install "bin", "lib"
    (bin/"frege-repl").write_env_script libexec/"bin/frege-repl", JAVA_HOME: Formula["openjdk@17"].opt_prefix
  end

  test do
    assert_match "65536", pipe_output(bin/"frege-repl", "println $ 64*1024\n:quit\n")
  end
end
