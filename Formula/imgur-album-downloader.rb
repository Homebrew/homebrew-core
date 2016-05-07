class ImgurAlbumDownloader < Formula
  desc "Command Line Utility to Download Imgur Albums"
  homepage "https://github.com/sgsunder/imgur-album-downloader"
  url "https://github.com/alexgisby/imgur-album-downloader.git", :revision => "dbaee1e342c1b46c022fccd26c294e251ac04015"
  version "1"

  bottle :unneeded

  depends_on "python3"

  def install
    mv "imguralbum.py", "imgur-album-downloader" # Rename Command Line Script
    bin.install "imgur-album-downloader"
  end

  test do
    system "#{bin}/imgur-album-downloader" # This should print the help message and return with exit code 0
  end
end
