# Documentation: https://github.com/Homebrew/brew/blob/master/docs/Formula-Cookbook.md
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Borg < Formula
  desc "A terminal based search engine for bash commands"
  homepage "https://github.com/crufter/borg"
  url "https://github.com/crufter/borg/releases/download/v0.0.1/borg_darwin_amd64"
  version "0.0.1"
  sha256 "69e75c846fa4212eaf6be26b5ff49266afcd9a46712948a16b1d406da51d8ddf"

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel

    system "mv", "#{bin}/borg_darwin_amd64", "#{bin}/borg"
    system "chmod", "755", "#{bin}/borg"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test borg`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "#{bin}/borg", "-p", "brew"
  end
end
