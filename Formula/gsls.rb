class Gsls < Formula
  desc "Get a quick overview of Git repositories with gs, a alternative to ls"
  homepage "https://github.com/non-existing-organization/golang-gsls"
  url "https://github.com/non-existing-organization/golang-gsls/releases/download/v0.1.1/golang-gsls-0.1.1.tar.gz"
  version "0.1.1"
  sha256 "e94324cac0245158ce8e1a9337f3b9a5431e513f9cc2c4d7641773f698bede3a"
  license "Unlicense"

  def install
    if OS.mac?
      bin.install "gs_darwin_amd64" => "gsls"
    elsif OS.linux?
      bin.install "gs_linux_amd64" => "gsls"
    elsif OS.windows?
      bin.install "gs_windows_amd64.exe" => "gsls.exe"
    end
  end

  test do
    system "#{bin}/gsls"
  end
end
