class Pdsh < Formula
  desc "Efficient rsh-like utility, for using hosts in parallel"
  homepage "https://github.com/chaos/pdsh"
  url "https://github.com/chaos/pdsh/releases/download/pdsh-2.36/pdsh-2.36.tar.gz"
  sha256 "a661095ce51dd5fb05e398cf5d0e1d63157123958441f6d3512bcf1a7d25c517"
  license "GPL-2.0-or-later"
  head "https://github.com/chaos/pdsh.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "a564810e0a1cb41ec26b36c13c8b2b6c61142b40247a9757c913736f8944229e"
    sha256 arm64_sequoia: "762213faa587a650e47efc58e3f3f98ef3cd9a9098dd53a4d5b79e0b3c22a07d"
    sha256 arm64_sonoma:  "757dd6e07011e89bbaf03c303fe236cc84f74d35326e0606062a14facdf21a99"
    sha256 sonoma:        "532a6d3910c0fe45dc28b62550ae89226fdcb1ac78cb3ea572bd82998a03037e"
    sha256 arm64_linux:   "7b13aaecfc7fdae5d427cb40b6b16fabdb4bcfb254eda223a255a2b595767299"
    sha256 x86_64_linux:  "abff1ce27177dcf72aa53e438b8934544fc52745301b1e187a1c3c7904b2930f"
  end

  depends_on "readline"

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --with-nodeupdown
      --with-readline
      --with-ssh
      --with-dshgroups
      --with-netgroup
      --with-slurm
      --without-rsh
      --without-xcpu
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"pdsh", "-V"
  end
end
