class Genext2fs < Formula
  desc "Generates an ext2 filesystem as a normal (non-root) user"
  homepage "https://genext2fs.sourceforge.net/"
  url "https://github.com/bestouff/genext2fs/archive/refs/tags/v1.6.3.tar.gz"
  sha256 "e3503a5bae3fd4b5b2c2d4f49b5b7f8d08e7accb20ab28c0f9647389b2c8a079"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7ffa223b355e771a691489e6e4c29bf0aa14ed7525152a184393705956af3710"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "19ec4b0b8fb9b9e6b9830566e37b7b0435227cef2ec768cf53548e0a354f0150"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "736e56e7b2f07cc5e22cf4c176c07881b49d6d60e0bc69bdca7e0c46d98dbe3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "fb296a5722ab03ecd56a05d609ef08e4bb7ccb047e7b66e73ef42bb112c8e2d6"
    sha256 cellar: :any_skip_relocation, sonoma:            "7f76028ee1aaf6e66a21b5680833f29a8dc5074691f6d3e1c3eb7df84e85b4d0"
    sha256 cellar: :any,                 arm64_linux:       "3a56007a9ad692ab51b100f3dc02b47c7915a400d526077d625614e4aa8e6202"
    sha256 cellar: :any,                 x86_64_linux:      "519507a41e89c153e17884befd473f386d08b782f4280407739529170e1d695b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    rootpath = testpath/"img"
    (rootpath/"foo.txt").write "hello world"
    system bin/"genext2fs", "--root", rootpath,
                               "--block-size", "4096",
                               "--size-in-blocks", "100",
                               "#{testpath}/test.img"
  end
end
