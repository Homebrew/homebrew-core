# Documentation: https://github.com/Homebrew/brew/blob/master/docs/Formula-Cookbook.md
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Checkcask < Formula
  desc "Checks which cask is to update for brew cask."
  homepage "https://github.com/AcePeak/checkcask"
  url "https://github.com/AcePeak/checkcask/releases/download/v0.1.0/checkcask-0.1.0.tar.gz"
  version "0.1.0"
  sha256 "b6eeccfce1df52ceb2b3b31318f09b6ee80639d9c8aaf8189d75648e105b3967"

  def install
    #system "./configure", "--disable-debug",
    #                      "--disable-dependency-tracking",
    #                      "--disable-silent-rules",
    #                      "--prefix=#{prefix}"
    #system "make", "install" # if this fails, try separate make/make install steps
    bin.install "checkcask"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test checkcask`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "checkcask"
  end
end
