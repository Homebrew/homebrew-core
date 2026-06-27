class Mtools < Formula
  desc "Tools for manipulating MSDOS files"
  homepage "https://www.gnu.org/software/mtools/"
  url "https://ftpmirror.gnu.org/gnu/mtools/mtools-4.0.49.tar.gz"
  mirror "https://ftp.gnu.org/gnu/mtools/mtools-4.0.49.tar.gz"
  sha256 "10cd1111da87bf2400a380c1639a6cba8bfb937a24f9c51f5f88d393ae5f6f76"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d7abe94bc09a3ff5ecb64d9a6c0dc37799b5ddd51c993d2480b2cee0567bef8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0f6aad93ce1be47de8f0d965033933a895f026caa8efc14e61431e6e5025d5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d09e38ca2a390336c1ae74821b15f84c08cbe89da16864c1d722b723d6b981d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ea3820f4a0897055a525bb47089538e13021a432bd7d7b65ab730dcc3da91fca"
    sha256 cellar: :any_skip_relocation, sonoma:        "befcc246e976f5f2669e27e33ef9a5b9a01745d5cf0dae4ed94e7f85d09c420d"
    sha256 cellar: :any_skip_relocation, ventura:       "373f8d9fe58ac60117d60dc996720e2335db25cd2113f9239e6ce694a411ba83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86d4b01db4192dc7cff8f6b1f8ac4ce36bed68ed1cab50de953c56e5f6e1085b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b35d3dda7886392a91cbfb237a7ab3c2f710ff6dc6875acedbbdec863d67c2b"
  end

  conflicts_with "mcat", because: "both install `mcat` binaries"
  conflicts_with "multimarkdown", because: "both install `mmd` binaries"

  def install
    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --without-x
    ]
    args << "LIBS=-liconv" if OS.mac?

    # The mtools configure script incorrectly detects stat64. This forces it off
    # to fix build errors on Apple Silicon. See stat(6) and pv.rb.
    ENV["ac_cv_func_stat64"] = "no" if Hardware::CPU.arm?

    system "./configure", *args
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mtools --version")
  end
end
