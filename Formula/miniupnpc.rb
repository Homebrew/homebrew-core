class Miniupnpc < Formula
  desc "UPnP IGD client library and daemon"
  homepage "https://miniupnp.tuxfamily.org"
  url "https://miniupnp.tuxfamily.org/files/download.php?file=miniupnpc-2.2.5.tar.gz"
  sha256 "38acd5f4602f7cf8bcdc1ec30b2d58db2e9912e5d9f5350dd99b06bfdffb517c"
  license "BSD-3-Clause"

  # We only match versions with only a major/minor since versions like 2.1 are
  # stable and versions like 2.1.20191224 are unstable/development releases.
  livecheck do
    url "https://miniupnp.tuxfamily.org/files/"
    regex(/href=.*?miniupnpc[._-]v?(\d+\.\d+(?>.\d{1,7})*)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f6ecafbc60eadb5fd14c12efce8f25b24ba5cf58d35700558072e8d1284d0298"
    sha256 cellar: :any,                 arm64_monterey: "a3ac9ac040fdb5c551b331812e16ad5815c0c4a1fffe76db1b8c50598d182746"
    sha256 cellar: :any,                 arm64_big_sur:  "f5cdb0a658e0365301886fa456c889df15b094439cbb5b3a0358e9f5076ca21e"
    sha256 cellar: :any,                 ventura:        "c5169ce164fb7f73958235a65fae51a976e323393738e0b580dff6e6ca059e98"
    sha256 cellar: :any,                 monterey:       "fb719f010b4936c1fe4117df0f80799075a8db33438ba85099508eac11420ff7"
    sha256 cellar: :any,                 big_sur:        "9ed146f123781d070d7f18716d567373fda2e28bc051ce8aaba3bb4aeb46f56e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e662068adb2eadd32d856f8ee3d634ce7b86238b9c89f034c8db56b79cf4637e"
  end

  def install
    system "make", "INSTALLPREFIX=#{prefix}", "install"
  end

  test do
    output = shell_output("#{bin}/upnpc --help 2>&1", 1)
    assert_match version.to_s, output
  end
end
