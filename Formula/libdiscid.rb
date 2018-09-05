class Libdiscid < Formula
  desc "C library for creating MusicBrainz and freedb disc IDs"
  homepage "https://musicbrainz.org/doc/libdiscid"
  url "http://ftp.musicbrainz.org/pub/musicbrainz/libdiscid/libdiscid-0.6.2.tar.gz"
  sha256 "f9e443ac4c0dd4819c2841fcc82169a46fb9a626352cdb9c7f65dd3624cd31b9"

  bottle do
    cellar :any
    sha256 "f6a415ae56c151ccef5e10cc239675be8cbd7dcf60a8b9c88c87a756bda5bd9a" => :mojave
    sha256 "3ffb586f09efcd9322a28bafc671292d0caf38edc18326c048a7390ced94979f" => :high_sierra
    sha256 "6d43fee98239a6a600e59cce0f4f2ceda713bf27cc3d03bc8711d1c773ba84b6" => :sierra
    sha256 "22e96d837cfe404cf268c41f6ce26c6b47eb8a991578ce1f18bcea862f9f1c91" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
