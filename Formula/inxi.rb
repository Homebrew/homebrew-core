class Inxi < Formula
  desc "Full featured CLI system information tool"
  homepage "https://smxi.org/docs/inxi.htm"
  url "https://github.com/smxi/inxi/archive/3.3.07-1.tar.gz"
  sha256 "d470c25df84bf1566d04a60842bc006ec6baf62ac700672790d1c6c183dafcef"
  license "GPL-3.0-or-later"
  head "https://github.com/smxi/inxi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "11f1cab9a4fa594cc294c7a2af45560cf31b403d64727008abed78e64c9c2f9f"
    sha256 cellar: :any_skip_relocation, big_sur:       "56c4ac39c896f43df8d7e929e1b96c4d260b6ebafdc87df8c91287b9bbd0a5e3"
    sha256 cellar: :any_skip_relocation, catalina:      "56c4ac39c896f43df8d7e929e1b96c4d260b6ebafdc87df8c91287b9bbd0a5e3"
    sha256 cellar: :any_skip_relocation, mojave:        "56c4ac39c896f43df8d7e929e1b96c4d260b6ebafdc87df8c91287b9bbd0a5e3"
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
