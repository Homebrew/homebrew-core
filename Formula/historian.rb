
# Documentation: http://docs.brew.sh/Formula-Cookbook.html
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Historian < Formula
  desc "Command-line utility for managing shell history in a SQLite database."
  homepage "https://github.com/jcsalterego/historian"
  url "https://files.jakemcknight.com/historian-0.1.tar.gz"
  sha256 "80981cf45b6c51dd2969a6d5cd2d69a488e9a58a411fc51d5bee68aaf267d7a5"
  version "0.1"

  # depends_on "cmake" => :build
  depends_on "sqlite"

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel

    # Remove unrecognized options if warned by configure
    bin.install 'hist'
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test hist`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "hist version"
  end
end
