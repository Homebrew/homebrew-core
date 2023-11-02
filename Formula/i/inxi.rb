class Inxi < Formula
  desc "Full featured CLI system information tool"
  homepage "https://smxi.org/docs/inxi.htm"
  url "https://github.com/smxi/inxi/archive/refs/tags/3.3.31-1.tar.gz"
  sha256 "5e2cce705a1dc865e8d90e63d4668f7a946b1349bf8bad141ddb69718fd46b60"
  license "GPL-3.0-or-later"
  head "https://github.com/smxi/inxi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ad9e66116af201abf3fa03aaf4d2f2ebbb40a0a6fb89926a90b0cfa7c9ffe22"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ad9e66116af201abf3fa03aaf4d2f2ebbb40a0a6fb89926a90b0cfa7c9ffe22"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ad9e66116af201abf3fa03aaf4d2f2ebbb40a0a6fb89926a90b0cfa7c9ffe22"
    sha256 cellar: :any_skip_relocation, sonoma:         "2c5f90a6ca8c8965238be427c3d77a41a4f82fcb8596b8bb00b2a695e4ed4775"
    sha256 cellar: :any_skip_relocation, ventura:        "2c5f90a6ca8c8965238be427c3d77a41a4f82fcb8596b8bb00b2a695e4ed4775"
    sha256 cellar: :any_skip_relocation, monterey:       "2c5f90a6ca8c8965238be427c3d77a41a4f82fcb8596b8bb00b2a695e4ed4775"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ad9e66116af201abf3fa03aaf4d2f2ebbb40a0a6fb89926a90b0cfa7c9ffe22"
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
