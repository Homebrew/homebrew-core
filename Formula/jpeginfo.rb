class Jpeginfo < Formula
  desc "Prints information and tests integrity of JPEG/JFIF files"
  homepage "https://www.kokkonen.net/tjko/projects.html"
  url "https://www.kokkonen.net/tjko/src/jpeginfo-1.7.0.tar.gz"
  sha256 "dc985083448d9707d42e49bed826a247c0dbda6913c870e9a5d9bf7c74939659"
  license "GPL-3.0-or-later"
  head "https://github.com/tjko/jpeginfo.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?jpeginfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "01ba4365d4bed48303ffe4b7eda697006ee978525a1c3e971ae1d43b2117b8f6"
    sha256 cellar: :any,                 arm64_monterey: "248d09ff5171378a89961669504198d95c9c403780f2c0b208a88d93b2b03359"
    sha256 cellar: :any,                 arm64_big_sur:  "2cd7083ee9be651a3879aa94e8cc5372c0e8815de5a31e6694c0413c794140c1"
    sha256 cellar: :any,                 ventura:        "de5b7688383ec8bbf434454f5cbb6522ac942419ef826ddadb2449a4a6fc4c57"
    sha256 cellar: :any,                 monterey:       "09642bc641e8a9e7e28b6f2db5f72fe5fddc24fe2a97d2ba48971a32db6683bd"
    sha256 cellar: :any,                 big_sur:        "6b03e7a143c3a2e209104418ac438dffd80f0a0d06754296d4d08e988110c359"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a6679a48a19077b9c232d8d1b45dbb0409409c12c183c66324317afe1cf9ddc"
  end

  depends_on "autoconf" => :build
  depends_on "jpeg-turbo"

  def install
    ENV.deparallelize

    # The ./configure file inside the tarball is too old to work with Xcode 12, regenerate:
    system "autoconf", "--force"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "#{bin}/jpeginfo", "--help"
  end
end
