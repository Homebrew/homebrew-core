class Aliyuncli < Formula
  desc "Alibaba Cloud CLI Go Edition 3.0.3"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "http://aliyun-cli.oss-cn-hangzhou.aliyuncs.com/aliyun-cli-macosx-3.0.3-amd64.tgz"
  sha256 "65fd8b3599c9e68e41cb128fb515265718fe70d37b52d3b6ea1e30dbdac17cd0"

  def install
    bin.install "aliyun"
  end

  test do
    assert_match "Alibaba", shell_output("#{bin}/aliyun --version")
  end
end
