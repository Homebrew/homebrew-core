class Cdrdao < Formula
  desc "Record CDs in Disk-At-Once mode"
  homepage "https://cdrdao.sourceforge.net/"
  url "https://github.com/cdrdao/cdrdao/archive/refs/tags/rel_1_2_6.tar.gz"
  sha256 "ba3eadcae7b62a709e9e23988d7fb41f822c408dcec9bd99ff1a343d1bcbc524"
  license "GPL-2.0-or-later"

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_tahoe:   "a87345e6d975df2e81170e4f82906ba52a913ae907fbff6c3b58b5d5660de8ed"
    sha256 arm64_sequoia: "f7a36ab54a5b3da81883df8c61d64485a1d2bd56990572a007ce1cfab9ab069d"
    sha256 arm64_sonoma:  "9f7020d598b9f7fc1604d960b75513ee23bd41ca661faabe05835630032dbc19"
    sha256 sonoma:        "51485a32c8e726d3096c8892994a04aedfb113e5ec239ea50a9ab0f85dd3cee4"
    sha256 arm64_linux:   "5f432a9e6e1268b9fbd139f73a7abac83a722e231b5b63a3403758c8d4c63524"
    sha256 x86_64_linux:  "2d5e0060a7c9e0e0efdce4393ecc9b608bd897685cb554855db8dc85f4ac8992"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "lame"
  depends_on "libao"
  depends_on "libvorbis"
  depends_on "mad"

  # Fixes build on macOS prior to 12.
  # Remove when merged and released.
  patch do
    url "https://github.com/cdrdao/cdrdao/commit/105d72a61f510e3c47626476f9bbc9516f824ede.patch?full_index=1"
    sha256 "0e235c0c34abaad56edb03a2526b3792f6f7ea12a8144cee48998cf1326894eb"
  end

  def install
    system "./autogen.sh"
    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "ERROR: No device specified, no default device found.",
     shell_output("#{bin}/cdrdao drive-info 2>&1", 1)
  end
end
