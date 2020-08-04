class Inxi < Formula
  desc "Full featured CLI system information tool"
  homepage "https://smxi.org/docs/inxi.htm"
  url "https://github.com/smxi/inxi/archive/3.1.05-2.tar.gz"
  version "3.1.05"
  sha256 "76dcb54b64269f61d0a8e23018ecda7a3a58b9c687eb587f93bd5b3bfa20b62a"
  license "GPL-3.0"
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
