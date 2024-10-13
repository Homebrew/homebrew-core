class Modman < Formula
  desc "Module deployment script geared towards Magento development"
  homepage "https://github.com/colinmollenhour/modman"
  url "https://github.com/colinmollenhour/modman/archive/refs/tags/1.14.tar.gz"
  sha256 "58ac5b27b11def9ba162881c3687f2085c06a6ed4cfb496bafdc64ce1a2eaac6"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "bc8e2c36d6029da01bd4c76d6a6261c3c114934f593a60377529b0468385b214"
  end

  def install
    bin.install "modman"
    bash_completion.install "bash_completion" => "modman.bash"
  end

  test do
    system bin/"modman"
  end
end
