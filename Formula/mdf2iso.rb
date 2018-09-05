class Mdf2iso < Formula
  desc "Tool to convert MDF (Alcohol 120% images) images to ISO images"
  homepage "https://packages.debian.org/sid/mdf2iso"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/m/mdf2iso/mdf2iso_0.3.1.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/m/mdf2iso/mdf2iso_0.3.1.orig.tar.gz"
  sha256 "906f0583cb3d36c4d862da23837eebaaaa74033c6b0b6961f2475b946a71feb7"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "444df3ab6a8ee34700f26459e93488d7ac3d3974ea29baa5d83f59d0014f6232" => :mojave
    sha256 "b41429cb8a4191a705b656b627a375cc32aaf8992cb241e30fe6c66c4ab56c9c" => :high_sierra
    sha256 "bc1358412281b1e486d9d1b6d25ae5665b02ac14f93f03603a966bd44ffda1d7" => :sierra
    sha256 "fbe092bfc501d4abf8b0df052e26307219ea4bb9fb4eddb20df8b7734ff7fdf5" => :el_capitan
    sha256 "aab6c1b85c8f863016f7db7ca6b35c56cc7442a6bdf6876f7b9b8ba24b58e5a6" => :yosemite
    sha256 "8a755700501039ec87145fa6acd0d37e9ecaacd538481bf556e7ed69330bd085" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdf2iso --help")
  end
end
