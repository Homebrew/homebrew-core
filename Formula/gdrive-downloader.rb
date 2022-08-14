class GdriveDownloader < Formula
  desc "Download a gdrive folder or file easily, shell ftw"
  homepage "https://github.com/Akianonymus/gdrive-downloader"
  url "https://github.com/Akianonymus/gdrive-downloader/archive/refs/tags/v1.0.tar.gz"
  sha256 "26c726bce41bff3b58c1f819a5c1f2e54d66b4ee3d592a5d52088de605c48d95"
  license "Unlicense"
  head "https://github.com/Akianonymus/gdrive-downloader.git", branch: "master"

  def install
    bin.install "release/bash/gdl"
  end

  test do
    assert_match "No valid arguments provided, use -h/--help flag to see usage.", \
      shell_output("#{bin}/gdl")
  end
end
