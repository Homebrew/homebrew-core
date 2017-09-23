class Faac < Formula
  desc "ISO AAC audio encoder"
  homepage "http://www.audiocoding.com/faac.html"
  url "https://downloads.sourceforge.net/project/faac/faac-src/faac-1.29/faac-1.29.7.5.tar.gz"
  sha256 "a9c36c49d6956eb78d062768927a87014dbb04573d7ce38e50a65a4772fc8016"

  bottle do
    cellar :any
    sha256 "4be7fc4894447708cab2d86f7089a2913e7cd0eff45544693fadbb593bd90815" => :high_sierra
    sha256 "ec05352ba412fb64cda82e4a964b9a0e6e625481a3d5b13a66db8be9d39d29f6" => :sierra
    sha256 "eb799e6822088371803fb833a44099cb1ab54ab1b775da3c858b85db963be411" => :el_capitan
    sha256 "1d3c4c9b4848d88a29d16702ab1d3e9cca5d2e801cf99886d9b13b38510f09ef" => :yosemite
  end

  # Remove for > 1.29.7.5
  # Fix "error: initializer element is not a compile-time constant"
  # Upstream commit from 23 Sep 2017 https://sourceforge.net/p/faac/faac/ci/4036f2c85038ef199a4636a6cbc4448f5e914d39
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/6f36b35/faac/clang-compatibility-fix.patch"
    sha256 "aab5d3636e6fe135b0137d2ea5f3800b3edf0225fa305a968ccabe92cf031e3f"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"faac", test_fixtures("test.mp3"), "-P", "-o", "test.m4a"
    assert File.exist?("test.m4a")
  end
end
