class MoonBuggy < Formula
  desc "Drive some car across the moon"
  homepage "https://www.seehuhn.de/pages/moon-buggy.html"
  url "https://m.seehuhn.de/programs/moon-buggy-1.0.tar.gz"
  sha256 "f8296f3fabd93aa0f83c247fbad7759effc49eba6ab5fdd7992f603d2d78e51a"
  license "GPL-2.0-or-later"

  # Upstream uses a similar version format for stable and unstable versions
  # (e.g. 1.0 is stable but 1.0.51 is experimental), so this identifies stable
  # versions by looking for the trailing `(stable version)` annotation.
  livecheck do
    url :homepage
    regex(/moon-buggy\s+(?:version\s+|v)?(\d+(?:\.\d+)+)[^<]+?\(stable\s+version\)/im)
  end

  bottle do
    sha256 arm64_sequoia:  "381b64031018e20366728e5b6cb559bb042e076f238a41aa0fd32a25d6094121"
    sha256 arm64_sonoma:   "5e84d8a0372bf17fda7d55ea77d6d3cc0bf4ab2a00f938657eb30fe3b7c119bf"
    sha256 arm64_ventura:  "b7dd2c4414457a17a2f548554fb1f2c97d2eab161732ec769b893c7c5f6183d5"
    sha256 arm64_monterey: "29c7f480f819b4c35a40537fa67645616ba35ba06405c9a433d516ae7684f3a4"
    sha256 arm64_big_sur:  "c7c5841b86bbd9271fb84c33e12babaf31e670dad45b2f65618e052dfbfae7ae"
    sha256 sonoma:         "e2cd8167429796321c2d3d421d4fa6845b09db0e2a35e7b69c7cd317f71ea41e"
    sha256 ventura:        "2a24441f98b7a24bec8165fd7c48a0543f11d1099439ae85de74884db0720247"
    sha256 monterey:       "991ffbd762b5a572066a44ce110b400e52892cf487e70e4fab64730c4f7f4fe7"
    sha256 big_sur:        "f4b3e7e9c36f357c628328b247bbe187467f16dde745acfd7ff2f668c22c379e"
    sha256 catalina:       "65bae44959589316ec4762947051a3f737ea8545d0b93e696d0c251ef38285dc"
    sha256 mojave:         "d7baa37058fd1e08a0a9028a912288bde8c0699b50f7632ce792d19d52c9fa73"
    sha256 high_sierra:    "54948d0646240382661b765ab2253258946fb10b2974587d719b24a771172d91"
    sha256 sierra:         "fb2abda84d3e2b20f286caa036fadb9bfd6c4df151352a171385a54ca43acda9"
    sha256 el_capitan:     "b71bfe4abfb1d2c3d35db544850cb56f1b2ba50df18d27d3fef3ed5845b30e76"
    sha256 x86_64_linux:   "72e827a7015b8a6d3fa38358221125375c8c4d2ae96b6c47a391714706dcfdbf"
  end

  head do
    url "https://github.com/seehuhn/moon-buggy.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  uses_from_macos "ncurses"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}"
    system "make", "install"
  end

  test do
    assert_match(/Moon-Buggy #{version}$/, shell_output("#{bin}/moon-buggy -V"))
  end
end
