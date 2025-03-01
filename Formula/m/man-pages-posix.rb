class ManPagesPosix < Formula
  desc "POSIX manual pages"
  homepage "https://web.git.kernel.org/pub/scm/docs/man-pages/man-pages-posix.git/"
  url "https://www.kernel.org/pub/linux/docs/man-pages/man-pages-posix/man-pages-posix-2017-a.tar.xz"
  version "2017-a"
  sha256 "ce67bb25b5048b20dad772e405a83f4bc70faf051afa289361c81f9660318bc3"

  # Allows distribution as long as the license is present
  license :cannot_represent

  def install
    system "make", "install", "prefix=#{prefix}"
    doc.install "POSIX-COPYRIGHT", "README", "man-pages-posix-#{version}.Announce"
  end

  test do
    assert_path_exists Pathname("#{man1}p/man.1p")
  end
end
