# Installs a relatively minimalist version of the GPAC tools. The
# most commonly used tool in this package is the MP4Box metadata
# interleaver, which has relatively few dependencies.
#
# The challenge with building everything is that Gpac depends on
# a much older version of FFMpeg and WxWidgets than the version
# that Brew installs

class Gpac < Formula
  desc "Multimedia framework for research and academic purposes"
  homepage "https://gpac.wp.mines-telecom.fr/"
  url "https://github.com/gpac/gpac/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "8173ecc4143631d7f2c59f77e1144b429ccadb8de0d53a4e254389fb5948d8b8"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/gpac/gpac.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "243d9269d097f534c5df53d0e3a4f75ccfb632ce9ebdd68814a2d0bc9aaae332"
    sha256 cellar: :any,                 arm64_ventura:  "461021a0d9ed70e310ed500fd5a634df5f80b1655f263a8ad8e43b4e7311a4a4"
    sha256 cellar: :any,                 arm64_monterey: "354ac657f5a4245c079a8ab82eb2983f7eaab6caf8dbf5b278015d9ddf7f4350"
    sha256 cellar: :any,                 sonoma:         "82c443a00849f02d4dd6f19dd55a4d35219e46029b8191077555e3c9e65bb9de"
    sha256 cellar: :any,                 ventura:        "125e19dc918de8e1b9653c69bf84ec63afcd7ccaa49944c119be18c57a94dd1b"
    sha256 cellar: :any,                 monterey:       "7dc6bcae8298a7de5f5e6ee63226a503107ad7aac48b9986d2279eef546ce97d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c44bcf2a3d20fb5cd07c6327b3939b1aecec642c97bbf31966f67b70b68c70db"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  conflicts_with "bento4", because: "both install `mp42ts` binaries"

  # https://github.com/gpac/gpac/issues/2673
  patch do
    url "https://github.com/gpac/gpac/commit/ce2202796a1630129cdff42cc1c02c3a8ea7a75f.patch?full_index=1"
    sha256 "708ff80d95fcfd28720c6c56a9c32c76bb181911fa8f6cb9a0f38c8012e96e9d"
  end

  # https://github.com/gpac/gpac/issues/2406
  patch do
    url "https://github.com/gpac/gpac/commit/ba14e34dd7a3c4cef5a56962898e9f863dd4b4f3.patch?full_index=1"
    sha256 "22ea4f6e93ec457468759bf5599903bea5171b1216472d09967fc9c558fa9fb3"
  end

  def install
    args = %W[
      --disable-wx
      --disable-pulseaudio
      --prefix=#{prefix}
      --mandir=#{man}
      --disable-x11
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/MP4Box", "-add", test_fixtures("test.mp3"), "#{testpath}/out.mp4"
    assert_predicate testpath/"out.mp4", :exist?
  end
end
