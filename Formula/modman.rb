class Modman < Formula
  desc "Module deployment script geared towards Magento development"
  homepage "https://github.com/colinmollenhour/modman"
  url "https://github.com/colinmollenhour/modman/archive/1.14.tar.gz"
  sha256 "58ac5b27b11def9ba162881c3687f2085c06a6ed4cfb496bafdc64ce1a2eaac6"
  license "Apache-2.0"

  bottle :unneeded

  def install
    bin.install "modman"
    bash_completion.install "bash_completion" => "modman.bash"
  end

  test do
    system "#{bin}/modman"
  end
end
