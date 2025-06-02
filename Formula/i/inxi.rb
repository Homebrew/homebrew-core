class Inxi < Formula
  desc "Full featured CLI system information tool"
  homepage "https://smxi.org/docs/inxi.htm"
  url "https://codeberg.org/smxi/inxi/archive/3.3.38-1.tar.gz"
  sha256 "9601b5d6287a2508a2e3c2652ce44190636dfe48371dc658e48ffc74af500b1b"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/smxi/inxi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4dda15963a7681aa6aa80c0296a464247a6a479557471c14bf255b913673b77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4dda15963a7681aa6aa80c0296a464247a6a479557471c14bf255b913673b77"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d4dda15963a7681aa6aa80c0296a464247a6a479557471c14bf255b913673b77"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb38cef399b732313bc2aba24bf42528a24d634c21571c783fecd33cc9ba30b3"
    sha256 cellar: :any_skip_relocation, ventura:       "bb38cef399b732313bc2aba24bf42528a24d634c21571c783fecd33cc9ba30b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4dda15963a7681aa6aa80c0296a464247a6a479557471c14bf255b913673b77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4dda15963a7681aa6aa80c0296a464247a6a479557471c14bf255b913673b77"
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
