class Libde265 < Formula
  desc "Open h.265 video codec implementation"
  homepage "https://github.com/strukturag/libde265"
  url "https://github.com/strukturag/libde265/releases/download/v1.0.15/libde265-1.0.15.tar.gz"
  sha256 "00251986c29d34d3af7117ed05874950c875dd9292d016be29d3b3762666511d"
  license "LGPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "1fed239f2b1a5a9e61745084d2c36041218f378970bc89ab84b0d1016ab7e585"
    sha256 cellar: :any,                 arm64_sonoma:   "cb6a409ae8d92ad4c96bf94b14e4987e102faf7ebdf264eeaee2180d091dccaa"
    sha256 cellar: :any,                 arm64_ventura:  "d72d238b5d13f6a9731cf29ace23fcf4f6538059ba1c0b7b9bcf06f49ce3aa52"
    sha256 cellar: :any,                 arm64_monterey: "29b0a2838055970a932a9f5a2a3c338d13bb9785066b33c745ed8f0b75a6e115"
    sha256 cellar: :any,                 sonoma:         "6b05ac06d5104b99cb0df1ea963c84b10403328f3991d00d5c94ed94a91e3b34"
    sha256 cellar: :any,                 ventura:        "0725e3968335cb67cc1165ab5eeafed9b6c1cd45d069b3ab0b14e3eb819e3101"
    sha256 cellar: :any,                 monterey:       "8695ef7abd578bbb838a2f735e178b0f1d30b58e5cc1c17a34a4225b6a7dd672"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d47718fc2bc23792e71cc2aa7d5cf8c6443d17d6df70e4f34dfe2b506a934cf4"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    extra_args = []
    extra_args << "--build=aarch64-apple-darwin#{OS.kernel_version}" if OS.mac? && Hardware::CPU.arm?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-sherlock265",
                          "--disable-dec265",
                          "--prefix=#{prefix}",
                          *extra_args
    system "make", "install"

    # Install the test-related executables in libexec.
    (libexec/"bin").install bin/"acceleration_speed",
                            bin/"block-rate-estim",
                            bin/"tests"
  end

  test do
    system libexec/"bin/tests"
  end
end
