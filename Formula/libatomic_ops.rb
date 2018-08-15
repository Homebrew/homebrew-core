class LibatomicOps < Formula
  desc "Implementations for atomic memory update operations"
  homepage "https://github.com/ivmai/libatomic_ops/"
  url "https://github.com/ivmai/libatomic_ops/releases/download/v7.6.6/libatomic_ops-7.6.6.tar.gz"
  sha256 "99feabc5f54877f314db4fadeb109f0b3e1d1a54afb6b4b3dfba1e707e38e074"

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
