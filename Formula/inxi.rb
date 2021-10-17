class Inxi < Formula
  desc "Full featured CLI system information tool"
  homepage "https://smxi.org/docs/inxi.htm"
  url "https://github.com/smxi/inxi/archive/3.3.07-1.tar.gz"
  sha256 "d470c25df84bf1566d04a60842bc006ec6baf62ac700672790d1c6c183dafcef"
  license "GPL-3.0-or-later"
  head "https://github.com/smxi/inxi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8de420370541d0cee6a7810ca0fe63191574c321b661bb7ba69381a12b621010"
    sha256 cellar: :any_skip_relocation, big_sur:       "625833eb573f13a34d9ee32a322a6b21412b565da619eba27d2e545536521c5c"
    sha256 cellar: :any_skip_relocation, catalina:      "625833eb573f13a34d9ee32a322a6b21412b565da619eba27d2e545536521c5c"
    sha256 cellar: :any_skip_relocation, mojave:        "625833eb573f13a34d9ee32a322a6b21412b565da619eba27d2e545536521c5c"
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
