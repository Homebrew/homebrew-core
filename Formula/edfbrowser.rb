class Edfbrowser < Formula
  desc "Edfbrowser"
  homepage "https://www.teuniz.net/edfbrowser/"
  url "https://www.teuniz.net/edfbrowser/edfbrowser_170_source.tar.gz"
  version "1.70"
  sha256 "206a19e47416c278fa161c6d9bd78a3a7dd5f2c2b88deb270fb3495ffd3f659d"

  depends_on "gcc" => :build
  depends_on "qt"

  def install
    system "qmake"
    system "make"

    bin.install "edfbrowser.app/Contents/MacOS/edfbrowser"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test sigviewer`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "#{bin}/edfbrowser", "--help"
  end
end
