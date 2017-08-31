class Mms < Formula
  desc "My mock server, mock HTTP server and proxy"
  homepage "https://github.com/LiushuiXiaoxia/MyMockServer"
  url "https://github.com/LiushuiXiaoxia/MyMockServer/raw/master/deploy/mms-0.1.tar"
  sha256 "274e458f2a30e2138a2e621bbb7cab6534d974c4396f404160ff1b7cbda02d6a"

  bottle :unneeded
  depends_on :java => "1.6+"

  def install
    libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/bin/MyMockServer" => "mms"

    lib.install_symlink "#{libexec}/lib" => "mms"
  end

  test do
    File.exist? "#{bin}/mms"
  end
end
