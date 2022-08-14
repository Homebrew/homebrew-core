class GoogleDriveUpload < Formula
  desc "Bash scripts to upload files to google drive"
  homepage "https://github.com/labbots/google-drive-upload"
  url "https://github.com/labbots/google-drive-upload/archive/refs/tags/v4.5.tar.gz"
  sha256 "143bf7521fab80f5b8f5edf4180648043f900c8aa357f0b021f9ce8b06207df5"
  license "MIT"
  head "https://github.com/labbots/google-drive-upload.git", branch: "master"

  def install
    bin.install "release/bash/gupload"
    bin.install "release/bash/gsync"
  end

  test do
    assert_match "No valid arguments provided, use -h/--help flag to see usage.", \
      shell_output("#{bin}/gupload")
    assert_match "No valid arguments provided, use -h/--help flag to see usage.", \
      shell_output("#{bin}/gsync")
  end
end
