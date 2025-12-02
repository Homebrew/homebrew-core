class GdriveDownloader < Formula
  desc "Download a gdrive folder or file easily, shell ftw"
  homepage "https://github.com/Akianonymus/gdrive-downloader"
  url "https://github.com/Akianonymus/gdrive-downloader/archive/refs/tags/v1.1.tar.gz"
  sha256 "aa1bf1a0a2cd6cc714292b2e83cf38fa37b99aac8f9d80ee92d619f156ddf4ba"
  license "Unlicense"
  head "https://github.com/Akianonymus/gdrive-downloader.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "7cef83ba18bc63e10eaa4ce67a439bdbd80c9248c9f123470aaef37b7d1f9000"
  end

  def install
    bin.install "release/bash/gdl"
  end

  test do
    assert_match "No valid arguments provided, use -h/--help flag to see usage.",
      shell_output("#{bin}/gdl")
  end
end
