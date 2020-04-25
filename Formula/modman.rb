class Modman < Formula
  desc "Module deployment script geared towards Magento development"
  homepage "https://github.com/colinmollenhour/modman"
  url "https://github.com/colinmollenhour/modman/archive/1.13.tar.gz"
  sha256 "d9efe8786826f54c3d2afa16f62a08e9a4e108cac429653a447055f6e5a0e8ec"

  bottle :unneeded

  def install
    bin.install "modman"
    bash_completion.install "bash_completion" => "modman.bash"
  end

  test do
    system "#{bin}/modman"
  end
end
