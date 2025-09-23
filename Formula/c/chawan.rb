class Chawan < Formula
  desc "TUI web browser with CSS, inline image and JavaScript support"
  homepage "https://sr.ht/~bptato/chawan/"
  url "https://git.sr.ht/~bptato/chawan/archive/v0.2.2.tar.gz"
  sha256 "30b4108247244f6b0721d44f84ba90cebf8ce5892ed9502d7e7c3fed92f65489"
  license "Unlicense"
  head "https://git.sr.ht/~bptato/chawan", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7a73b25243813225cdf93d521d5e287ed8bfc47bb8d637f049c399192dd59562"
    sha256 cellar: :any,                 arm64_sequoia: "b9be1da4b16cde2ad0788b0e0bf4ba6bd49129abff764b306be0cfe945de0fa5"
    sha256 cellar: :any,                 arm64_sonoma:  "bf1828157ded27c5ab4b92b37cdc856f3423c935effb72ac4e935f0d3e7a00d8"
    sha256 cellar: :any,                 arm64_ventura: "c5390f8597c1de9aa5ebd4883878dd0472b1f051e1a917c5098878fc3e411c20"
    sha256 cellar: :any,                 sonoma:        "d7ca58a40cac91a237133c3a60e909e23e2cc2eca528eef93ed214df0b061cd7"
    sha256 cellar: :any,                 ventura:       "2d1ba741fd41220c65b43c3f5c885fb18731aff4ccaead85032241e926a783b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f5c33dd69d3e449674adddb59224ebfcada16aaca4c8b02fa6ce77198e420b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28de6c68815eced2c3d09e239e8ef11d8e0ea36a23385752a9067b8da71738d3"
  end

  depends_on "nim" => :build
  depends_on "pkgconf" => :build

  depends_on "brotli"
  depends_on "libssh2"
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "ncurses"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cha --version")
    assert_match "Example Domain", shell_output("#{bin}/cha --dump https://example.com")
  end
end
