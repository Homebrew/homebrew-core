class DashShell < Formula
  desc "POSIX-compliant descendant of NetBSD's ash (the Almquist SHell)"
  homepage "http://gondor.apana.org.au/~herbert/dash/"
  url "https://cdn.netbsd.org/pub/pkgsrc/distfiles/dash-0.5.13.4.tar.gz"
  mirror "http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.13.4.tar.gz"
  sha256 "d10dfd41cda59165560db39ca915c2c4a7636fff04281d8d2df77ad92c753e2b"
  license "BSD-3-Clause"
  head "https://git.kernel.org/pub/scm/utils/dash/dash.git", branch: "master"

  livecheck do
    url "http://gondor.apana.org.au/~herbert/dash/files/"
    regex(/href=.*?dash[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c75a49c350d4ecc28a84f447150fc334c0b425597a93ea5e659fa7aca558e3e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4e5d5294d88281217866622358c3fe265c8a79b7392df3645aa8fc6292f84f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ff8e8f56a1929741b19ce3ba87e9bd74a657f2664cfd65aa0b9f19afa95cc0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b4f5254859c4f6372afa91665811842253904036c86aaa4177377823111551e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "673f3e4aeece044d39f65b3b59c2f04f574e9994820f15d38bf311dd4de3b60a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df699507803b50096396399863b830b44a904d3732649a915d26d89e76b31885"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "libedit"

  def install
    ENV["ac_cv_func_stat64"] = "no" if OS.mac? && Hardware::CPU.arm?
    system "./autogen.sh" if build.head?
    system "./configure", "--with-libedit", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"dash", "-c", "echo Hello!"
  end
end
