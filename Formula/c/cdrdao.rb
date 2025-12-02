class Cdrdao < Formula
  desc "Record CDs in Disk-At-Once mode"
  homepage "https://cdrdao.sourceforge.net/"
  url "https://github.com/cdrdao/cdrdao/archive/refs/tags/rel_1_2_5.tar.gz"
  sha256 "b347189ab550ae5bd1a19d323cdfd8928039853c23aa5e33d7273ab8c750692a"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "8bdc4963c13e5aa89fb923d6d15138740b978665301706598eccb6a41dd98d4b"
    sha256 arm64_sequoia:  "e743e2ad68e18dab5d0c92398fe17efabfe6a0bdc3ff070680446b6cb40ab6e9"
    sha256 arm64_sonoma:   "e4d1ccc44373ea37015384940c9bdfef60f847aa866cbb4406e7e39e50251b46"
    sha256 arm64_ventura:  "9bba142c6ea1c60866164731f20b0318488bef4e95dc337e471da95a44a3e6fc"
    sha256 arm64_monterey: "d2ff09195a2c3bba86481154a011e24ead7e9c5b21b3d62555a73fb1b2474928"
    sha256 arm64_big_sur:  "98cd14947ae08e97b3db38fd3ce134357f5b231de5a50aef0968ff7f3f9acbff"
    sha256 sonoma:         "b83a5d9a865e9e5ff9080e702870029780a7478ca1f62b4d1a5e1e50479782e2"
    sha256 ventura:        "ba6051c32784b80330a170abb8eb259fc277fb30aeaeb2fa8c0327f15bc3ee7b"
    sha256 monterey:       "4f53224ac3e0a2f4b7a88664f38258dfcbd82b1cc1e87330b5598a962b570a03"
    sha256 big_sur:        "8646d1973bae91ad66f3b3318a7fb1e91f321eef9be18db2cc533a7833af292e"
    sha256 arm64_linux:    "db49fc2472974c0e6f5ed25432f5b8612deb979f98bf77f72912767cc30bd473"
    sha256 x86_64_linux:   "4bfec99cba6093c485d981592128baa27150a47cf28e4f6bf80d887aeda6352b"
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
