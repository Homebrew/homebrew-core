class Bashish < Formula
  desc "Theme environment for text terminals"
  homepage "https://bashish.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/bashish/bashish/2.2.4/bashish-2.2.4.tar.gz"
  sha256 "3de48bc1aa69ec73dafc7436070e688015d794f22f6e74d5c78a0b09c938204b"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9de9a34d40236aa4fc76c38f69fa2b30b6d66bb1d6289a7552b543300abc753c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c18a9d6903c20ae676bfdae2152d8c71b86d2a918298fa9276878002e4ed3320"
    sha256 cellar: :any_skip_relocation, monterey:       "571da7c657359ce294d6cd556ef076cfcb8e80fdb44d7b9e494fd5207cb70afb"
    sha256 cellar: :any_skip_relocation, big_sur:        "19831ed9c970ba6d8fa4308ac70aa83148902f8057a029025f0bc6f3bad83900"
    sha256 cellar: :any_skip_relocation, catalina:       "19031477c5b06b25b69fb33d3c00e6cffccaaf578234e492ccc67ff187f8cbdc"
    sha256 cellar: :any_skip_relocation, mojave:         "7f2b297190ede9e55c0def858e37b25682268e6f0bc3df2c507e347e7ac353a5"
    sha256 cellar: :any_skip_relocation, high_sierra:    "b7caabd1274134f33dd458ac444bbe14a139de76b91f8bebb56349377b840a5e"
    sha256 cellar: :any_skip_relocation, sierra:         "31134b56c7ad43b04ef186485af8581dbf8d8d8fcf615d259554d9c5adc7233f"
    sha256 cellar: :any_skip_relocation, el_capitan:     "114d2ce95e530c6850bc36a52a1053ecf05185d774ed499bd1725811b3c1b88c"
    sha256 cellar: :any_skip_relocation, yosemite:       "cb3bfee8b595277be04660817eb269e97744d5f49dcac431ae7473982ad5d405"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9de9a34d40236aa4fc76c38f69fa2b30b6d66bb1d6289a7552b543300abc753c"
  end

  depends_on "dialog"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/bashish", "list"
  end
end
