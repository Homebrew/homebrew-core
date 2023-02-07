class Cdrdao < Formula
  desc "Record CDs in Disk-At-Once mode"
  homepage "https://cdrdao.sourceforge.io/"
  url "https://github.com/cdrdao/cdrdao/archive/refs/tags/rel_1_2_5.tar.gz"
  sha256 "b347189ab550ae5bd1a19d323cdfd8928039853c23aa5e33d7273ab8c750692a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "be033aee75694dcc9feb66deac2b9e0058041f18979bf9b5228c1e9a0f9cd572"
    sha256 arm64_monterey: "e5c979c90b6e103d80dcb19129cd5f1506ee3c72278641038c3c05c290646ad8"
    sha256 arm64_big_sur:  "29b520f278e11f6742704d93aa391c44dc5cb386f04610fefb07a787fbcf0595"
    sha256 ventura:        "9637d2ce7278309b853b12efad41de7aaa98617aa917db3b4b935c4aad8bf2d3"
    sha256 monterey:       "8bec2c3c92a145a9a50336e64e8aec69841013467d6be22d8ed16fa98e4df4a1"
    sha256 big_sur:        "1a2440998c344f7b1df9d01d6e3079f86fbc79e8827c440883fda7f8e12aa2fd"
    sha256 catalina:       "81acc38e0a51134c0eeebf20e76dcee4e80eabfac72f0ec890e448271a96792c"
    sha256 mojave:         "f8894deccbd18e7d5362ace73618666d9a79b233cea5dc6af367ab9e257332e0"
    sha256 high_sierra:    "1efaa356872419da65763a5e28faf262b79f5a37e2eb83c06c22e9846bae188f"
    sha256 sierra:         "cd0c72a2c84f084e4f5fe28df185e9154409645138e55502ffb9c4075ae4dfea"
    sha256 el_capitan:     "d49e947354162d163937e801fd00468823b16d8462e179f6cfe20a84eb19ffb5"
    sha256 x86_64_linux:   "3c86d5f308211f6fe68cf6c27d2c7fe5a59bd7f154382d9cdb5fff4c85fd5364"
  end

  depends_on "pkg-config" => :build
  depends_on "lame"
  depends_on "libao"
  depends_on "libvorbis"
  depends_on "mad"

  def install
    system "./configure", *std_configure_args, "--mandir=#{man}"
    system "make", "install"
  end
end
