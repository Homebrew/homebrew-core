class LibatomicOps < Formula
  desc "Implementations for atomic memory update operations"
  homepage "https://github.com/ivmai/libatomic_ops/"
  url "https://github.com/ivmai/libatomic_ops/releases/download/v7.6.4/libatomic_ops-7.6.4.tar.gz"
  sha256 "5b823d5a685dd70caeef8fc50da7d763ba7f6167fe746abca7762e2835b3dd4e"

  bottle do
    cellar :any_skip_relocation
    sha256 "ce3c9fd22f329bcc0161de61061c3ef4058664a58993cead3b0dc9eebcd73ff7" => :high_sierra
    sha256 "72210cf477e6eaa39232383ca9912fef5d025a7cc91c40db16bdb85533124736" => :sierra
    sha256 "2e1070711abeefa9ea329fbae5881c1caba725d5d0f9c3b4d21845593bdd3a72" => :el_capitan
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
