class ChromeExport < Formula
  desc "Convert Chrome’s bookmarks and history to HTML bookmarks files"
  homepage "https://github.com/bdesham/chrome-export"
  url "https://github.com/bdesham/chrome-export/archive/v2.0.2.tar.gz"
  sha256 "41b667b407bc745a57105cc7969ec80cd5e50d67e1cce73cf995c2689d306e97"
  license "ISC"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f51c4b63ddf95b8e9b317bb52b9ea9be6d1f498fdbe6853f0ec15dabf0f35b26"
  end

  def install
    bin.install "export-chrome-bookmarks"
    bin.install "export-chrome-history"
    man1.install "man_pages/export-chrome-bookmarks.1"
    man1.install "man_pages/export-chrome-history.1"
    pkgshare.install "test"
  end

  test do
    cp_r (pkgshare/"test").children, testpath
    system bin/"export-chrome-bookmarks", "Bookmarks",
           "bookmarks_actual_output.html"
    assert_predicate testpath/"bookmarks_actual_output.html", :exist?
    assert_equal (testpath/"bookmarks_expected_output.html").read,
                 (testpath/"bookmarks_actual_output.html").read
    system bin/"export-chrome-history", "History", "history_actual_output.html"
    assert_predicate testpath/"history_actual_output.html", :exist?
    assert_equal (testpath/"history_expected_output.html").read,
                 (testpath/"history_actual_output.html").read
  end
end
