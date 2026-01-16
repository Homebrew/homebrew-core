class Lsdvd < Formula
  desc "Read the content info of a DVD"
  homepage "https://sourceforge.net/projects/lsdvd/"
  url "https://git.code.sf.net/p/lsdvd/git.git",
      tag:      "0.21",
      revision: "de9cf2379335076368cc848de04a60279d944b68"
  license "GPL-2.0-only"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "854b44a0716635a744a6deed7eddd2661d613dbff82b55090b29326a7a302306"
    sha256 cellar: :any,                 arm64_sequoia: "5c5bd9c12da6fda6bce4718fe8657afa4865517e1e08a1112ada89725e3a0e7a"
    sha256 cellar: :any,                 arm64_sonoma:  "d5ddb6d8f67c637c854a6b09806c51c7ee3dd5588a3c0aba656919555e853ed8"
    sha256 cellar: :any,                 sonoma:        "78e3cfc9ffaf25187125a7eb66e1cc4e8ca3bebd017330a8a50b3208a3d782db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6cb0bebbc1be23440c8fa57039b03f196e52fc59b6dc87177ee7255dc28012ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb64d0cda764af93c0ae41ace40dfcc89a5c388388e981003a214b4f3d688b57"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "libdvdcss"
  depends_on "libdvdread"
  depends_on "libxml2"

  # Move `dvdlogger` function out of `main()`, as Clang (rightfully) does not allow nested functions
  # Can be removed once this has been merged: https://sourceforge.net/p/lsdvd/git/merge-requests/2/
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/443cea9c2797b473f4069aad0e12ff06521333b7/Patches/lsdvd/logging.patch"
    sha256 "5879230867a18b52264428b064e2b5f96423563da1409909f85e0f2163e0ae94"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"lsdvd", "--help"
  end
end
