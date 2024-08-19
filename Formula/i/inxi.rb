class Inxi < Formula
  desc "Full featured CLI system information tool"
  homepage "https://smxi.org/docs/inxi.htm"
  url "https://codeberg.org/smxi/inxi/archive/3.3.35-1.tar.gz"
  sha256 "08e43312bc60435d770607c3611f2fa35478ea0f48c60d5d5fd60ab2ee421f2e"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/smxi/inxi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9fb5b8e89607a8168c5afd2a000c8d30ae4d791f43307456bdc5935fe76a2856"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9fb5b8e89607a8168c5afd2a000c8d30ae4d791f43307456bdc5935fe76a2856"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fb5b8e89607a8168c5afd2a000c8d30ae4d791f43307456bdc5935fe76a2856"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c3e0ead40b496916e109f692bbc55f131a415da1e1976b58c478d91a96e5adb"
    sha256 cellar: :any_skip_relocation, ventura:        "9c3e0ead40b496916e109f692bbc55f131a415da1e1976b58c478d91a96e5adb"
    sha256 cellar: :any_skip_relocation, monterey:       "9c3e0ead40b496916e109f692bbc55f131a415da1e1976b58c478d91a96e5adb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be7db540b44c91bd65ef2f298d6cfbaaeda79d2e37907704594c3d6fa33dc209"
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
    inxi_output = shell_output(bin/"inxi")
    uname_r = shell_output("uname -r").strip
    assert_match uname_r.to_str, inxi_output.to_s
  end
end
