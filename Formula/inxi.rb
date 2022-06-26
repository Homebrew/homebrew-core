class Inxi < Formula
  desc "Full featured CLI system information tool"
  homepage "https://smxi.org/docs/inxi.htm"
  url "https://github.com/smxi/inxi/archive/3.3.19-1.tar.gz"
  sha256 "bf8881c140eac6fd266e32db31bcd90d93c5e3d429c426aacfb295d0e57e1bd9"
  license "GPL-3.0-or-later"
  head "https://github.com/smxi/inxi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb51b22181b68460ade685b88d697c3b97e01534cc1ba1d6c4a4d245b2a55f6d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb51b22181b68460ade685b88d697c3b97e01534cc1ba1d6c4a4d245b2a55f6d"
    sha256 cellar: :any_skip_relocation, monterey:       "6d8315a833249edc40f1bb82f50a64ecc0d7f0749cd9a1fa79f74417e1d6d635"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d8315a833249edc40f1bb82f50a64ecc0d7f0749cd9a1fa79f74417e1d6d635"
    sha256 cellar: :any_skip_relocation, catalina:       "6d8315a833249edc40f1bb82f50a64ecc0d7f0749cd9a1fa79f74417e1d6d635"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb51b22181b68460ade685b88d697c3b97e01534cc1ba1d6c4a4d245b2a55f6d"
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
