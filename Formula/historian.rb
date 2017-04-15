class Historian < Formula
  desc "Command-line utility for managing shell history in a SQLite database."
  homepage "https://github.com/jcsalterego/historian"
  url "https://github.com/jcsalterego/historian/archive/0.0.2.tar.gz"
  sha256 "80981cf45b6c51dd2969a6d5cd2d69a488e9a58a411fc51d5bee68aaf267d7a5"

  depends_on "sqlite"

  def install
    bin.install "hist"
  end

  test do
    ENV["HISTORIAN_SRC"] = "./.bash_history"
    system bin/"hist", "import"
  end
end
