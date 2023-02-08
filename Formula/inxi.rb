class Inxi < Formula
  desc "Full featured CLI system information tool"
  homepage "https://smxi.org/docs/inxi.htm"
  url "https://github.com/smxi/inxi/archive/3.3.25-1.tar.gz"
  sha256 "17176e70516adae4adced317905ab759316e5658a55c4a002c130bbcc21af3b7"
  license "GPL-3.0-or-later"
  head "https://github.com/smxi/inxi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "470420b152f5c368e8f65335d93426909352358b477c93c14e69eedefcee63ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "470420b152f5c368e8f65335d93426909352358b477c93c14e69eedefcee63ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "470420b152f5c368e8f65335d93426909352358b477c93c14e69eedefcee63ea"
    sha256 cellar: :any_skip_relocation, ventura:        "ef8b58931939019f61e9a94137020898f8e04fc2b1c3d0aacd6fc506d64e6e64"
    sha256 cellar: :any_skip_relocation, monterey:       "ef8b58931939019f61e9a94137020898f8e04fc2b1c3d0aacd6fc506d64e6e64"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef8b58931939019f61e9a94137020898f8e04fc2b1c3d0aacd6fc506d64e6e64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "470420b152f5c368e8f65335d93426909352358b477c93c14e69eedefcee63ea"
  end

  uses_from_macos "perl"

  def install
    bin.install "inxi"
    man1.install "inxi.1"

    ["LICENSE.txt", "README.txt", "inxi.changelog"].each do |file|
      prefix.install file
    end
  end

  test do
    inxi_output = shell_output("#{bin}/inxi")
    uname_r = shell_output("uname -r").strip
    assert_match uname_r.to_str, inxi_output.to_s
  end
end
