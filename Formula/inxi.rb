class Inxi < Formula
  desc "Full featured CLI system information tool"
  homepage "https://smxi.org/docs/inxi.htm"
  url "https://github.com/smxi/inxi/archive/3.3.22-1.tar.gz"
  sha256 "718051fd275a03e9e488443ac73fe399e82c3be02745401672ae7567b150c6b5"
  license "GPL-3.0-or-later"
  head "https://github.com/smxi/inxi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43e0e20fd58605138df8388f4e28e934d2efe699da5941fb24459447c9909a5b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43e0e20fd58605138df8388f4e28e934d2efe699da5941fb24459447c9909a5b"
    sha256 cellar: :any_skip_relocation, monterey:       "d6b42668a157da9def64b2bedba8dadbecfedddb63499920867cda6ebcb7c32c"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6b42668a157da9def64b2bedba8dadbecfedddb63499920867cda6ebcb7c32c"
    sha256 cellar: :any_skip_relocation, catalina:       "d6b42668a157da9def64b2bedba8dadbecfedddb63499920867cda6ebcb7c32c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43e0e20fd58605138df8388f4e28e934d2efe699da5941fb24459447c9909a5b"
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
