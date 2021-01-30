class Inxi < Formula
  desc "Full featured CLI system information tool"
  homepage "https://smxi.org/docs/inxi.htm"
  url "https://github.com/smxi/inxi/archive/3.3.00-1.tar.gz"
  version "3.3.00-1"
  sha256 "1180dd8dc71690322ec28f0ee7d9e013adea67bc94298742cfc5a2b4eefff6b9"
  license "GPL-3.0-or-later"
  head "https://github.com/smxi/inxi.git"

  bottle :unneeded

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
