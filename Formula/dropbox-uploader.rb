class DropboxUploader < Formula
  desc "Bash script for interacting with Dropbox"
  homepage "https://www.andreafabrizi.it/2016/01/01/Dropbox-Uploader/"
  url "https://github.com/andreafabrizi/Dropbox-Uploader/archive/1.0.tar.gz"
  sha256 "8c9be8bd38fb3b0f0b4d1a863132ad38c8299ac62ecfbd1e818addf32b48d84c"

  bottle :unneeded

  def install
    bin.install "dropbox_uploader.sh", "dropShell.sh"
  end

  test do
    (testpath/".dropbox_uploader").write <<~EOS
      APPKEY=a
      APPSECRET=b
      ACCESS_LEVEL=sandbox
      OAUTH_ACCESS_TOKEN=c
      OAUTH_ACCESS_TOKEN_SECRET=d
    EOS
    pipe_output("#{bin}/dropbox_uploader.sh unlink", "y\n")
  end
end
