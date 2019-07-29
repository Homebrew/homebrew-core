class Nyancat < Formula
  desc "Renders an animated, color, ANSI-text loop of the Poptart Cat"
  homepage "https://github.com/klange/nyancat"
  url "https://github.com/klange/nyancat/archive/1.5.2.tar.gz"
  sha256 "88cdcaa9c7134503dd0364a97fa860da3381a09cb555c3aae9918360827c2032"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f14b77291021020bc45ea2182063fe16215faee9862786763798362ac664822" => :mojave
    sha256 "2272aa5028ca779224f68fd25a3c07ff41c71bb7d14511186808a6b59bfe32c3" => :high_sierra
    sha256 "413a6ff99b622e60b0878ca74c3051d0feac094a7eb1fa9e90db715735cdd2bf" => :sierra
    sha256 "2484fb6eabaaa65a988191b9c2f920d7290bc20f73dbf41e4a996e0306827364" => :el_capitan
  end

  # Makefile: Add install directory option
  patch do
    url "https://github.com/klange/nyancat/pull/34.patch?full_index=1"
    sha256 "24a0772d2725e151b57727ce887f4b3911d19e875785eb7e13a68f4b987831e8"
  end

  def install
    system "make"
    system "make", "install", "instdir=#{prefix}"
  end

  test do
    system "#{bin}/nyancat", "--frames", "1"
  end
end
