class GdriveDownloader < Formula
  desc "Download a gdrive folder or file easily, shell ftw."
  homepage "https://github.com/Akianonymus/gdrive-downloader"
  url "https://github.com/Akianonymus/gdrive-downloader.git"
  version "2022-08-15"
  head "https://github.com/Akianonymus/gdrive-downloader.git", branch: "master"
  license "Unlicense"

  def install
    bin.install "release/bash/gdl"
  end

  test do
    system "#{bin}/gdl"
  end
end
