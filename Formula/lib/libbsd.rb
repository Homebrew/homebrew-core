class Libbsd < Formula
  desc "Utility functions from BSD systems"
  homepage "https://libbsd.freedesktop.org/"
  url "https://libbsd.freedesktop.org/releases/libbsd-0.12.2.tar.xz"
  sha256 "b88cc9163d0c652aaf39a99991d974ddba1c3a9711db8f1b5838af2a14731014"
  license "BSD-3-Clause"

  livecheck do
    url "https://libbsd.freedesktop.org/releases/"
    regex(/href=.*?libbsd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "5dfeeefe2e5f10d343c990d68b31c3c77c39df8151bd2279da69f7004a5302da"
    sha256 cellar: :any,                 arm64_sequoia: "e9bd43f6679707dbe86536dd3d9daefd9988db71b911d9b1fd7bbb04658b446c"
    sha256 cellar: :any,                 arm64_sonoma:  "aa3c342efa7b87672ed780f3ac53680a5493f0e267eab9d71cd4d4380146342c"
    sha256 cellar: :any,                 arm64_ventura: "3f8b9f7545d170c69e15ba9e24edb7cf7cb98ccda39dd3c8a4ed0d28c75b7bb5"
    sha256 cellar: :any,                 sonoma:        "4fc8e8c21ed393023cae19ff35ec7b5faf7df85c9bc843dafcb7f96b5b1f8537"
    sha256 cellar: :any,                 ventura:       "110fd177f3769fc485f1deff7a88c1f268d588fffcc9c58c0919ce4a3a30b6d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6c6c7d6349ce9b9aab5c6a6db366e4538d0911e4619e14ce51838a683ad3d92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31fb2290fe313559d9de741089809ea8d5bc8cffdaf8237f350c6d2f836bba95"
  end

  depends_on "libmd"

  def install
    system "./configure",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    libbsd = lib/shared_library("libbsd", version.major.to_s)
    assert_match "strtonum", shell_output("nm #{libbsd}")
  end
end
