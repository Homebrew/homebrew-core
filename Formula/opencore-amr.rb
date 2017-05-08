class OpencoreAmr < Formula
  desc "Audio codecs extracted from Android open source project"
  homepage "https://opencore-amr.sourceforge.io/"
  url "https://downloads.sourceforge.net/opencore-amr/opencore-amr-0.1.5.tar.gz"
  sha256 "2c006cb9d5f651bfb5e60156dbff6af3c9d35c7bbcc9015308c0aff1e14cd341"

  bottle do
    cellar :any
    sha256 "425fbe7604961f21ac05150585e77311094159ffe13b1ce2de816f36482482ad" => :sierra
    sha256 "92bdd75efff4d4c94822847d9ddda34a70abd8dec5a28c6875b071394d31b7a6" => :el_capitan
    sha256 "c97e0859a55c074d5679d7fc63df608041ae8258d737cb56cfad997f8c82eba2" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
