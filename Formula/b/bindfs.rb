class Bindfs < Formula
  desc "FUSE file system for mounting to another location"
  homepage "https://bindfs.org/"
  url "https://bindfs.org/downloads/bindfs-1.18.0.tar.gz"
  sha256 "46fcf95b871109265e93cd42e5ae282c722716488ad9f0da1e1f98535be37f7a"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://bindfs.org/downloads/"
    regex(/href=.*?bindfs[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "367dce693fae2e1107ed9fce1e4971ad3c3bf32d9ec9bb85e8ff8a37c8758b4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e22505f7582f8eda7a6bc912ebf7b99f1567b1d5e75e1ac12a782bcaf99b9cce"
  end

  head do
    url "https://github.com/mpartel/bindfs.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE

  def install
    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"bindfs", "-V"
  end
end
