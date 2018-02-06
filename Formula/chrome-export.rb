class ChromeExport < Formula
  desc "Convert Chrome’s bookmarks and history to HTML bookmarks files"
  homepage "https://github.com/bdesham/chrome-export"
  url "https://github.com/bdesham/chrome-export/archive/v2.0.tar.gz"
  sha256 "ff972c3d88b030b65823388e08cd65ebd8795f0674b5581e9e8fdf3a0f4dc7ef"

  depends_on "python"

  def install
    bin.install "export-chrome-bookmarks"
    bin.install "export-chrome-history"

    # Install the test files in case someone wants to run "brew test" later;
    # compress them first so that they take up as little space as possible.
    system "tar", "-cJf", "test_files.xz", "test"
    share.install "test_files.xz"
  end

  test do
    system "tar", "-xJf", share.join("test_files.xz")
    Dir.chdir "test" do
      system "#{bin}/export-chrome-bookmarks", "Bookmarks", "bookmarks_actual_output.html"
      compare_file "bookmarks_expected_output.html", "bookmarks_actual_output.html"
      system "#{bin}/export-chrome-history", "History", "history_actual_output.html"
      compare_file "history_expected_output.html", "history_actual_output.html"
    end
  end
end
