class Inxi < Formula
  desc "Full featured CLI system information tool"
  homepage "https://smxi.org/docs/inxi.htm"
  url "https://github.com/smxi/inxi/archive/3.3.06-1.tar.gz"
  sha256 "39161866ef737c9fca4a4fb16d7c07cab14987bf3b22ea346c51609772f76b08"
  license "GPL-3.0-or-later"
  head "https://github.com/smxi/inxi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2c17cbe704e1fe20f67f347c8ce4328ad727b5f43e4655392a91d7388daee537"
    sha256 cellar: :any_skip_relocation, big_sur:       "d50ddbd84f7710b56ffb391de3414f960873f72aaac299eb6d7325cbceaa2376"
    sha256 cellar: :any_skip_relocation, catalina:      "d50ddbd84f7710b56ffb391de3414f960873f72aaac299eb6d7325cbceaa2376"
    sha256 cellar: :any_skip_relocation, mojave:        "d50ddbd84f7710b56ffb391de3414f960873f72aaac299eb6d7325cbceaa2376"
  end

  def install
    bin.install "inxi"
    man1.install "inxi.1"

    ["LICENSE.txt", "README.txt", "inxi.changelog"].each do |file|
      prefix.install file
    end
  end

  test do
    inxi_output = shell_output("#{bin}/inxi")

    uname = shell_output("uname").strip
    assert_match uname.to_str, inxi_output.to_s

    uname_r = shell_output("uname -r").strip
    assert_match uname_r.to_str, inxi_output.to_s
  end
end
