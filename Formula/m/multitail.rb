class Multitail < Formula
  desc "Tail multiple files in one terminal simultaneously"
  homepage "https://vanheusden.com/multitail/"
  url "https://github.com/folkertvanheusden/multitail/archive/refs/tags/7.1.2.tar.gz"
  sha256 "c8552e10093f0690b8baef84945753c878e234d7b3d0e3ff27e509ed5515998c"
  license "Apache-2.0"
  head "https://github.com/folkertvanheusden/multitail.git"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f3fc083b287b8f49b9c79ca1951be8f5032ad00f839110eb8a778dc2487925fd"
    sha256 cellar: :any,                 arm64_ventura:  "98444fd682fdb68e33acef1864f3364d2048a50c4d707453bafbf04246314e86"
    sha256 cellar: :any,                 arm64_monterey: "65cfe67e4d5634b323c1bf70a5d8264f52b26320083188af4a1f68a0db7cf67f"
    sha256 cellar: :any,                 sonoma:         "074de6e786a2ba9a0f45415eab5977fb9adf4edf88996931ceba3d6f4bb45827"
    sha256 cellar: :any,                 ventura:        "a453421f0d555ad4b6be1d09b91f3bd8d90801e0990df31ca1e3316f8e017a77"
    sha256 cellar: :any,                 monterey:       "79ba0b2ef4b92fba512392fef29417216feb83a6e598f3dbfec0c3afb8254bf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa9ed05dd7832ab4b6f705d3196f13f8c0526ee74db4ac9dbdfb4c6d96be0f41"
  end

  depends_on "pkg-config" => :build
  depends_on "ncurses"

  def install
    system "make", "-f", "makefile.macosx", "multitail", "DESTDIR=#{HOMEBREW_PREFIX}"

    bin.install "multitail"
    man1.install Utils::Gzip.compress("multitail.1")
    etc.install "multitail.conf"
  end

  test do
    if build.head?
      assert_match "multitail", shell_output("#{bin}/multitail -h 2>&1", 1)
    else
      assert_match version.to_s, shell_output("#{bin}/multitail -h 2>&1", 1)
    end
  end
end
