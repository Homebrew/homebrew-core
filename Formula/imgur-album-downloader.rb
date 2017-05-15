class ImgurAlbumDownloader < Formula
  desc "Command Line Utility to Download Imgur Albums"
  homepage "https://github.com/Szero/imgur-album-downloader"
  url "https://github.com/Szero/imgur-album-downloader.git", :revision => "13500208e28d200fd687a25b5c218a6dcfac1190"
  version "1"

  bottle :unneeded

  depends_on "python3"

  def install
    bin.install "imguralbum.py" => "imgur-album-downloader" # Rename Command Line Script
  end

  test do
    system "#{bin}/imgur-album-downloader", "http://imgur.com/a/ej9g4" # Download test album
  end
end
