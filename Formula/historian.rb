class Historian < Formula
  desc "Command-line utility for managing shell history in a SQLite database."
  homepage "https://github.com/jcsalterego/historian"
  url "https://files.jakemcknight.com/historian-0.1.tar.gz"
  sha256 "80981cf45b6c51dd2969a6d5cd2d69a488e9a58a411fc51d5bee68aaf267d7a5"

  depends_on "sqlite"

  def install
    bin.install "hist"
  end

  test do
    system "/usr/local/bin/hist", "version"
  end
end
