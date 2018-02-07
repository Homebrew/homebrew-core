class ChromeExport < Formula
  desc "Convert Chrome’s bookmarks and history to HTML bookmarks files"
  homepage "https://github.com/bdesham/chrome-export"
  url "https://github.com/bdesham/chrome-export/archive/v2.0.tar.gz"
  sha256 "ff972c3d88b030b65823388e08cd65ebd8795f0674b5581e9e8fdf3a0f4dc7ef"

  depends_on "python" if MacOS.version <= :snow_leopard

  def install
    bin.install "export-chrome-bookmarks"
    bin.install "export-chrome-history"

    pkgshare.install "test"
  end

  test do
    cp_r "#{pkgshare}/test/.", "."

    system "#{bin}/export-chrome-bookmarks", "Bookmarks", "bookmarks_actual_output.html"
    compare_file "bookmarks_expected_output.html", "bookmarks_actual_output.html"
    system "#{bin}/export-chrome-history", "History", "history_actual_output.html"
    compare_file "history_expected_output.html", "history_actual_output.html"
  end
end
