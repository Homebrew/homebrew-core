# Documentation: https://github.com/Homebrew/brew/blob/master/docs/Formula-Cookbook.md
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Handbrake < Formula
  desc "HandBrake is an open-source video transcoder available for Linux, Mac, and Windows, licensed under the GNU General Public License (GPL) Version 2."
  homepage "https://handbrake.fr/"
  url "https://github.com/HandBrake/HandBrake/archive/0.10.5.tar.gz"
  sha256 "1e3aab0be004b05129579f1068a8d4664b23f83d55ca2d8c72f9935c319d2e0a"
  version "0.10.5"
  head "https://github.com/HandBrake/HandBrake.git"

  depends_on "yasm" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel

    # Remove unrecognized options if warned by configure
    system "./configure", "--debug=none",
                          "--prefix=#{prefix}",
                          "--disable-xcode"
                          "--disable-gtk"
    system "make", "install" # if this fails, try separate make/make install steps
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test HandBrake`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
