class Historian < Formula
  desc "Command-line utility for managing shell history in a SQLite database"
  homepage "https://github.com/jcsalterego/historian"
  url "https://github.com/jcsalterego/historian/archive/0.0.2.tar.gz"
  sha256 "691b131290ddf06142a747755412115fec996cb9cc2ad8e8f728118788b3fe05"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f1887b168f03631cb1a51fb419940d8f2bee1e9fb658cc1cd130ded4aa0951eb"
  end

  def install
    bin.install "hist"
  end

  test do
    ENV["HISTORIAN_SRC"] = "test_history"
    (testpath/"test_history").write <<~EOS
      brew update
      brew upgrade
    EOS
    system bin/"hist", "import"
  end
end
