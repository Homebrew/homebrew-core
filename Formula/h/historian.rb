class Historian < Formula
  desc "Command-line utility for managing shell history in a SQLite database"
  homepage "https://github.com/jcsalterego/historian"
  url "https://github.com/jcsalterego/historian/archive/refs/tags/0.0.2.tar.gz"
  sha256 "691b131290ddf06142a747755412115fec996cb9cc2ad8e8f728118788b3fe05"
  license "BSD-2-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "189a00a7ac7714b8c9c9f5aa6691278538a072629bc6fa24ab99812d37b9e58d"
  end

  uses_from_macos "sqlite"

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
