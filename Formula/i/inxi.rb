class Inxi < Formula
  desc "Full featured CLI system information tool"
  homepage "https://smxi.org/docs/inxi.htm"
  url "https://github.com/smxi/inxi/archive/3.3.29-1.tar.gz"
  sha256 "5802cc6fe780fb9f24a097c326ffce9b31abe2f5b70957e21c6973e008bbf44b"
  license "GPL-3.0-or-later"
  head "https://github.com/smxi/inxi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95614d0c99300f386142dc66811192efb1134449de5f0a20963784f686de3851"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95614d0c99300f386142dc66811192efb1134449de5f0a20963784f686de3851"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95614d0c99300f386142dc66811192efb1134449de5f0a20963784f686de3851"
    sha256 cellar: :any_skip_relocation, ventura:        "8a9bd17e375977f50d9d8eed11884a44d0547d9134fc319c19e12e3236907140"
    sha256 cellar: :any_skip_relocation, monterey:       "8a9bd17e375977f50d9d8eed11884a44d0547d9134fc319c19e12e3236907140"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a9bd17e375977f50d9d8eed11884a44d0547d9134fc319c19e12e3236907140"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95614d0c99300f386142dc66811192efb1134449de5f0a20963784f686de3851"
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
