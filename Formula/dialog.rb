class Dialog < Formula
  desc "Display user-friendly message boxes from shell scripts"
  homepage "https://invisible-island.net/dialog/"
  url "https://invisible-mirror.net/archives/dialog/dialog-1.3-20190808.tgz"
  sha256 "886e12f2cf3df36cde65f32f6ae52bc598eb2599a611b1d8ce5dfdea599e47e2"

  bottle do
    cellar :any_skip_relocation
    sha256 "47d5c4ac5913ff36ec7b8d4aa2d4fa2206ba4408dbdf5a24d7faac324e4264f7" => :mojave
    sha256 "d47c369a985ab8761cbdb3ceda72ed9d059557b206252f36b31830c1dab8f462" => :high_sierra
    sha256 "20fc5cc9a9ea20a873d3143cd629ebff9cac22fd14fef6f6f46c6bb0febeadf9" => :sierra
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
