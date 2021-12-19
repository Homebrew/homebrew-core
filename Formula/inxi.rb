class Inxi < Formula
  desc "Full featured CLI system information tool"
  homepage "https://smxi.org/docs/inxi.htm"
  url "https://github.com/smxi/inxi/archive/3.3.11-1.tar.gz"
  sha256 "424db24db457d3b87661f12fdc94e68a63e57ab4eb9982ccba2078451be79c59"
  license "GPL-3.0-or-later"
  head "https://github.com/smxi/inxi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76637671804c3208eb8c6f6a91b18c176f081c87dccc56ac5d3a186415b4ba04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76637671804c3208eb8c6f6a91b18c176f081c87dccc56ac5d3a186415b4ba04"
    sha256 cellar: :any_skip_relocation, monterey:       "0fe08ec2fcb25809b963a79194731992b26283d06ff30c2730bf6121f0343489"
    sha256 cellar: :any_skip_relocation, big_sur:        "0fe08ec2fcb25809b963a79194731992b26283d06ff30c2730bf6121f0343489"
    sha256 cellar: :any_skip_relocation, catalina:       "0fe08ec2fcb25809b963a79194731992b26283d06ff30c2730bf6121f0343489"
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
