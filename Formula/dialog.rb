class Dialog < Formula
  desc "Display user-friendly message boxes from shell scripts"
  homepage "https://invisible-island.net/dialog/"
  url "https://invisible-mirror.net/archives/dialog/dialog-1.3-20190211.tgz"
  sha256 "49c0e289d77dcd7806f67056c54f36a96826a9b73a53fb0ffda1ffa6f25ea0d3"

  bottle do
    cellar :any_skip_relocation
    sha256 "32cebb02cee6af547b0b630c63007f0d91af34eae2b435cc103238c01b6ff840" => :mojave
    sha256 "569a0789237caabf189ee499f02ebf76fe87d2a3ec261fbbe5e131bc80742f13" => :high_sierra
    sha256 "bc2e02e165c9fc28dd339d511944c22cdedbd97ec9d02d897d097f9e41535565" => :sierra
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
