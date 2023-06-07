class FregeRepl < Formula
  desc "REPL (read-eval-print loop) for Frege"
  homepage "https://github.com/Frege/frege-repl"
  url "https://github.com/Frege/frege-repl/releases/download/1.4-SNAPSHOT/frege-repl-1.4-SNAPSHOT.zip"
  version "1.4-SNAPSHOT"
  sha256 "2ca5f13bc5efaf8515381e8cdf99b4d4017264a462a30366a873cb54cc4f4640"
  license "BSD-3-Clause"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "17666cf7857b6fbd4af5f30a97a5c0d36b90f0514e58af14b07173ddece6e9a3"
  end

  # TODO: Switch to `openjdk` on next release.
  depends_on "openjdk@17"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install "bin", "lib"
    (bin/"frege-repl").write_env_script libexec/"bin/frege-repl", JAVA_HOME: Formula["openjdk@17"].opt_prefix
  end

  test do
    assert_match "65536", pipe_output("#{bin}/frege-repl", "println $ 64*1024\n:quit\n")
  end
end
