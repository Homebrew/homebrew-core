class Modman < Formula
  desc "Module deployment script geared towards Magento development"
  homepage "https://github.com/colinmollenhour/modman"
  url "https://github.com/colinmollenhour/modman/archive/refs/tags/1.14.tar.gz"
  sha256 "58ac5b27b11def9ba162881c3687f2085c06a6ed4cfb496bafdc64ce1a2eaac6"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "f932bb64388501a75aff2a97fe0b75b6bbefa13d38f29d99cf49672015aba60d"
  end

  def install
    bin.install "modman"
    bash_completion.install "bash_completion" => "modman"
  end

  test do
    system bin/"modman"
  end
end
