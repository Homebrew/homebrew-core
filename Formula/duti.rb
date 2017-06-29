class Duti < Formula
  desc "Select default apps for documents and URL schemes on macOS"
  homepage "https://github.com/moretension/duti/"
  url "https://github.com/moretension/duti/archive/duti-1.5.3.tar.gz"
  sha256 "0e71b7398e01aedf9dde0ffe7fd5389cfe82aafae38c078240780e12a445b9fa"
  head "https://github.com/moretension/duti.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "8f34c5664b0a9c05274fd67102fca6c969f7dc966279b2ca0f11906df3d2d03a" => :sierra
    sha256 "53748f3ad97a48b468326e66d869e20c05fc1f67219ac3ea8a147b558717ee45" => :el_capitan
    sha256 "c2661fc4e59d5cc941a416bf7abad035af3d15f75e7bca73d2bc29706d89f560" => :yosemite
    sha256 "e301c36a6809acc2a0dd62fba59eac4820b90cf2cf9df30f46480f7ce736dad3" => :mavericks
  end

  depends_on "autoconf" => :build

  # Add hardcoded SDK path for El Capitan or later.
  # See https://github.com/moretension/duti/pull/20.
  if MacOS.version >= :el_capitan
    patch do
      url "https://github.com/moretension/duti/pull/20.patch?full_index=1"
      sha256 "2dee8e25f7c53a9fa4cbd756ad06b308e7eabb385cf589aba02bc7f50ae76c3e"
    end
  end

  def install
    system "autoreconf", "-vfi"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/duti", "-x", "txt"
  end
end
