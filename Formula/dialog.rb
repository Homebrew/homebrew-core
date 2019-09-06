class Dialog < Formula
  desc "Display user-friendly message boxes from shell scripts"
  homepage "https://invisible-island.net/dialog/"
  url "https://invisible-mirror.net/archives/dialog/dialog-1.3-20190728.tgz"
  sha256 "e5eb0eaaef9cae8c822887bd998e33c2c3b94ebadd37b4f6aba018c0194a2a87"

  bottle do
    cellar :any_skip_relocation
    sha256 "b13955830b83cb96b1ed1a5fe837bed18b445beda97c11d6d900bfc561177347" => :mojave
    sha256 "61d4452a033133dfb6f0c5b9504e9cf759be742766efbf24c287001294c005ce" => :high_sierra
    sha256 "512670cf32f5ef5e24568963be9571330b3ccead0042678e6d6bd76fd4844de8" => :sierra
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install-full"
  end

  test do
    system "#{bin}/dialog", "--version"
  end
end
